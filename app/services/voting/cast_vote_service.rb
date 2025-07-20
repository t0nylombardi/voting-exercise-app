# frozen_string_literal: true

require "ostruct"

module Voting
  # Service class responsible for processing and recording user votes in an election system.
  #
  # This service handles:
  # - Vote validation (preventing duplicate votes)
  # - Candidate name matching and fuzzy search suggestions
  # - Write-in candidate creation with constraints
  # - Vote recording and vote count updates
  #
  # @example Basic usage
  #   result = CastVoteService.call(user: current_user, candidate_name: "John Smith")
  #   if result.success?
  #     puts "Vote cast for #{result.candidate.name}"
  #   else
  #     puts "Error: #{result.error}"
  #   end
  #
  # @example Handling fuzzy matches
  #   result = CastVoteService.call(user: current_user, candidate_name: "Jon Smyth")
  #   # Returns: "Did you mean 'John Smith'?" if similarity is between 0.85 and threshold
  class CastVoteService
    # Initializes a new vote casting service instance.
    #
    # @param user [User] The user attempting to cast a vote
    # @param candidate_name [String] The name of the candidate to vote for
    def initialize(user:, candidate_name:)
      @user = user
      @candidate_name = normalize_name(candidate_name)
    end

    # Class method for convenient one-line service calls.
    # Creates a new instance and immediately calls it.
    #
    # @param user [User] The user attempting to cast a vote
    # @param candidate_name [String] The name of the candidate to vote for
    # @return [OpenStruct] Result object with success? boolean and either candidate or error
    def self.call(user:, candidate_name:)
      new(user:, candidate_name:).call
    end

    # Main entry point for casting a vote.
    # Performs all necessary validations and creates the vote record.
    #
    # @return [OpenStruct] Success result with candidate, or failure result with error message
    #
    # Process flow:
    # 1. Check if user has already voted
    # 2. Resolve the candidate (existing, fuzzy match, or create write-in)
    # 3. Create vote record and increment candidate's vote count
    def call
      return failure("Already voted") if user.voted?

      candidate = resolve_candidate
      return failure(candidate[:error]) if candidate.is_a?(Hash)

      Vote.create!(user_id: user.id, candidate_id: candidate.id)
      candidate.increment!(:votes_count)
      success(candidate)
    end

    private

    # @!attribute [r] user
    #   @return [User] The user casting the vote
    # @!attribute [r] candidate_name
    #   @return [String] The normalized candidate name
    attr_reader :user, :candidate_name

    # Normalizes candidate names for consistent storage and matching.
    # Removes leading/trailing whitespace and converts to title case.
    #
    # @param name [String] Raw candidate name input
    # @return [String] Normalized name (stripped and titleized)
    #
    # @example
    #   normalize_name("  john smith  ") #=> "John Smith"
    #   normalize_name("JANE DOE") #=> "Jane Doe"
    def normalize_name(name)
      name.strip.downcase.titleize
    end

    # Resolves the candidate to vote for using fuzzy matching and write-in logic.
    #
    # @return [Candidate, Hash] Either a Candidate object or error hash
    #
    # Resolution logic:
    # 1. Use CandidateMatcherService to find potential matches
    # 2. If similarity score is in suggestion range (0.85 to threshold), return suggestion
    # 3. If exact match exists, return the candidate
    # 4. If no match, validate write-in constraints and create new candidate
    def resolve_candidate
      matcher = CandidateMatcherService.call(candidate_name)

      fuzzy_match_suggestion = check_fuzzy_match(matcher)
      return fuzzy_match_suggestion if fuzzy_match_suggestion

      matcher.existing? ? matcher.best_match : handle_write_in_candidate
    end

    # Checks if the matcher found a near-miss that should trigger a suggestion.
    #
    # @param matcher [CandidateMatcherService] The matcher result
    # @return [Hash, nil] Error hash with suggestion, or nil if no suggestion needed
    def check_fuzzy_match(matcher)
      return unless matcher.best_match_score.between?(0.85, CandidateMatcherService::SIMILARITY_THRESHOLD)

      {error: "Did you mean '#{matcher.best_match.name}'?"}
    end

    # Handles the creation of a write-in candidate with proper validation.
    #
    # @return [Candidate, Hash] New candidate or error hash if validation fails
    def handle_write_in_candidate
      error = validate_write_in_constraints
      return {error: error} if error

      create_write_in_candidate
    end

    # Creates a new write-in candidate and associates it with the user.
    # This allows users to vote for candidates not initially on the ballot.
    #
    # @return [Candidate] The newly created candidate record
    #
    # Side effects:
    # - Creates new Candidate record with the normalized name
    # - Updates user record to track their write-in candidate
    def create_write_in_candidate
      candidate = Candidate.create!(name: candidate_name)
      user.update!(write_in: candidate)
      candidate
    end

    # Validates business rules for write-in candidates.
    # Enforces system limits and user constraints.
    #
    # @return [String, nil] Error message if validation fails, nil if valid
    #
    # Constraints checked:
    # - Maximum of 10 candidates total in the system
    # - Users can only create one write-in candidate each
    def validate_write_in_constraints
      return "Too many candidates" if Candidate.count >= 10
      return "Already wrote in a candidate" if user.write_in.present?
      nil
    end

    # Creates a success result object.
    #
    # @param candidate [Candidate] The candidate that received the vote
    # @return [OpenStruct] Success result with success? = true and candidate data
    def success(candidate)
      OpenStruct.new(success?: true, candidate:)
    end

    # Creates a failure result object.
    #
    # @param error [String] Description of what went wrong
    # @return [OpenStruct] Failure result with success? = false and error message
    def failure(error)
      OpenStruct.new(success?: false, error:)
    end
  end
end
