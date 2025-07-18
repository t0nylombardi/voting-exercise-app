# frozen_string_literal: true

module Voting
  class ResultsFetcher
    def self.call
      new.call
    end

    def call
      Candidate
        .left_joins(:votes)
        .group("candidates.id")
        .order("COUNT(votes.id) DESC")
        .pluck(:name, Arel.sql("COUNT(votes.id)"))
        .map { |name, count| {name:, votes: count} }
    end
  end
end
