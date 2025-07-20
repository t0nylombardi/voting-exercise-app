# frozen_string_literal: true

require "amatch"

module Voting
  # Service class responsible for fuzzy matching candidate names in an election system.
  #
  # This service uses the Jaro-Winkler algorithm to find the best matching candidate
  # from existing candidates based on string similarity. It's designed to handle
  # typos, alternative spellings, and minor variations in candidate names.
  #
  # The service determines whether a match is "good enough" using a configurable
  # similarity threshold. Matches above the threshold are considered existing
  # candidates, while matches below suggest the user may want a write-in candidate.
  #
  # @example Basic usage
  #   matcher = CandidateMatcherService.call("Jon Smith")
  #   if matcher.existing?
  #     puts "Found existing candidate: #{matcher.best_match.name}"
  #   else
  #     puts "No close match found (score: #{matcher.best_match_score})"
  #   end
  #
  # @example Handling near misses
  #   matcher = CandidateMatcherService.call("Kendrik Lamar")
  #   # If "Kendrick Lamar" exists with 0.95 similarity:
  #   matcher.existing? #=> true
  #   matcher.best_match.name #=> "Kendrick Lamar"
  #   matcher.best_match_score #=> 0.95
  class CandidateMatcherService
    include Amatch

    # Minimum similarity score (0.0-1.0) required to consider a candidate an "existing" match.
    # Scores above this threshold indicate the input likely refers to an existing candidate.
    # Scores below suggest a potential write-in candidate or typo requiring user confirmation.
    SIMILARITY_THRESHOLD = 0.9

    # @!attribute [r] input_name
    #   @return [String] The normalized candidate name to search for
    attr_reader :input_name

    # Initializes a new candidate matcher with the given input name.
    # The input name is automatically normalized (stripped and titleized).
    #
    # @param input_name [String] The candidate name to search for
    def initialize(input_name)
      @input_name = normalize(input_name)
    end

    # Class method for convenient one-line service calls.
    # Creates a new instance and immediately processes the match.
    #
    # @param input_name [String] The candidate name to search for
    # @return [CandidateMatcherService] Configured service instance with results
    def self.call(input_name)
      new(input_name).tap(&:call)
    end

    # Processes the candidate matching and returns self for method chaining.
    # This method exists primarily to maintain consistency with other service objects
    # and allow for future expansion of the matching logic.
    #
    # @return [CandidateMatcherService] Self, allowing access to match results
    def call
      return best_match if existing?

      nil
    end

    # Returns the candidate with the highest similarity score to the input name.
    # Uses Jaro-Winkler algorithm to calculate string similarity.
    #
    # @return [Candidate, nil] The best matching candidate, or nil if no candidates exist
    def best_match
      candidates_with_scores.max_by { |_, score| score }&.first
    end

    # Returns the similarity score of the best matching candidate.
    # Scores range from 0.0 (no similarity) to 1.0 (identical strings).
    #
    # @return [Float] Similarity score between 0.0 and 1.0, or 0.0 if no candidates
    def best_match_score
      _, score = candidates_with_scores.max_by { |_, score| score }
      score || 0.0
    end

    # Determines if the best match exceeds the similarity threshold.
    # Used to decide whether to treat the input as referring to an existing candidate
    # or as a potential write-in candidate.
    #
    # @return [Boolean] true if best match score >= SIMILARITY_THRESHOLD
    def existing?
      best_match_score >= SIMILARITY_THRESHOLD
    end

    private

    # Normalizes candidate names for consistent comparison.
    # Removes leading/trailing whitespace and converts to title case.
    #
    # @param name [String] Raw candidate name
    # @return [String] Normalized name (stripped and titleized)
    def normalize(name)
      name.downcase.titleize.strip
    end

    # Retrieves all candidates from the database.
    # This method exists to enable easy mocking in tests and potential
    # future filtering or scoping of candidates.
    #
    # @return [ActiveRecord::Relation] All candidate records
    def candidates
      Candidate.all
    end

    # Calculates similarity scores for all candidates against the input name.
    # Uses Jaro-Winkler algorithm which is particularly effective for names
    # as it gives higher scores to strings that match from the beginning.
    #
    # @return [Array<Array<Candidate, Float>>] Array of [candidate, score] pairs
    #
    # Performance note: This method loads all candidates into memory and calculates
    # scores for each. In the future, we should move this into database-level fuzzy matching.
    def candidates_with_scores
      matcher = JaroWinkler.new(input_name)
      candidates.map do |candidate|
        [candidate, matcher.match(normalize(candidate.name))]
      end
    end
  end
end
