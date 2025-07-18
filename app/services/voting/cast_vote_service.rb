# frozen_string_literal: true

require 'ostruct'

# Service object for casting a vote for a candidate.
#
# This service handles the logic for casting a vote by a user, including:
# - Checking if the user has already voted.
# - Finding an existing candidate or creating a new write-in candidate.
# - Validating write-in candidate constraints (e.g., max candidates, one write-in per user).
# - Creating the vote record.
#
# @example Cast a vote for a candidate
#   result = Voting::CastVoteService.call(user: user, candidate_name: "Jane Doe")
#   if result.success?
#     puts "Vote cast for #{result.candidate.name}"
#   else
#     puts "Vote failed: #{result.error}"
#   end
#
# @see ApplicationService
#
# @param user [User] The user casting the vote.
# @param candidate_name [String] The name of the candidate to vote for.
#
# @return [OpenStruct] Result object with:
#   - success? [Boolean] Whether the vote was successfully cast.
#   - candidate [Candidate] The candidate voted for (if successful).
#   - error [String] Error message (if unsuccessful).
#
# @raise [ActiveRecord::RecordInvalid] If saving a candidate or vote fails.
module Voting
  class CastVoteService
    def initialize(user:, candidate_name:)
      @user = user
      @candidate_name = candidate_name.strip.titleize
    end

    def self.call(user:, candidate_name:)
      new(user: user, candidate_name: candidate_name).call
    end

    # Executes the service to cast a vote.
    #
    # @return [OpenStruct] Result object with:
    #   - success? [Boolean] Whether the vote was successfully cast.
    #   - candidate [Candidate] The candidate voted for (if successful).
    #   - error [String] Error message (if unsuccessful).
    #
    # @raise [ActiveRecord::RecordInvalid] If saving a candidate or vote fails.
    def call
      return failure("Already voted") if already_voted?

      candidate = find_or_create_candidate
      return failure(candidate[:error]) if candidate.is_a?(Hash) && candidate[:error]

      create_vote(candidate)
      success(candidate: candidate)
    end

    private

    attr_reader :user, :candidate_name

    # Checks if the user has already voted.
    #
    # @return [Boolean] Whether the user has already voted.
    def already_voted?
      user.voted?
    end

    # Finds an existing candidate or creates a new write-in candidate.
    #
    # @return [Candidate, Hash] The found or created candidate, or an error hash.
    def find_or_create_candidate
      candidate = find_candidate
      return candidate if candidate.persisted?

      error = validate_write_in_candidate
      return {error: error} if error

      create_write_in_candidate(candidate)
    end

    # Finds an existing candidate by name.
    #
    # @return [Candidate] The found candidate.
    def find_candidate
      Candidate.find_or_initialize_by(name: candidate_name)
    end

    # Creates a new write-in candidate.
    #
    # @param [Candidate] candidate The candidate to create.
    #
    # @return [Candidate] The created candidate.
    def create_write_in_candidate(candidate)
      candidate.save!
      user.update!(write_in: candidate)
      candidate
    end

    # Validates the write-in candidate constraints.
    #
    # @return [String, nil] Error message (if invalid), or nil (if valid).
    # @note Constraints include:
    #   - Maximum of 10 candidates.
    #   - User can only write in one candidate.
    #
    # @see Candidate#count
    # @see User#write_in
    # @see User#voted?
    def validate_write_in_candidate
      return "Too many candidates" if Candidate.count >= 10
      return "Already wrote in a candidate" if user.write_in.present?
      nil
    end

    # Creates a new vote for the given candidate.
    #
    # @param [Candidate] candidate The candidate to vote for.
    # @return [Vote] The created vote.
    def create_vote(candidate)
      Vote.create!(user_id: user.id, candidate_id: candidate.id)
      candidate.increment!(:votes_count)
    end

    # Returns a success result with the candidate.
    #
    # @param [Candidate] candidate The candidate that was voted for.
    # @return [OpenStruct] The success result.
    def success(candidate:)
      OpenStruct.new(success?: true, candidate:)
    end

    # Returns a failure result with the error.
    #
    # @param [String] error The error message.
    # @return [OpenStruct] The failure result.
    def failure(error)
      OpenStruct.new(success?: false, error:)
    end
  end
end
