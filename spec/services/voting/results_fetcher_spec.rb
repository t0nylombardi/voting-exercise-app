# frozen_string_literal: true

require "rails_helper"

RSpec.describe Voting::ResultsFetcher, type: :service do
  subject(:fetch_results) { described_class.call }

  describe ".call" do
    context "when there are no candidates" do
      it "returns an empty array" do
        expect(fetch_results).to be_empty
      end
    end

    context "when candidates exist" do
      let(:high_vote_candidate) { create(:candidate, name: "Kendrick Lamar") }
      let(:low_vote_candidate) { create(:candidate, name: "Eminem") }
      let(:votes_by_name) { fetch_results.index_by { |result| result[:name] } }
      let(:users) { create_list(:user, 3) }

      before do
        users.each do |user|
          create(:vote, user: user, candidate: high_vote_candidate)
        end
        create(:vote, user: users.first, candidate: low_vote_candidate)
        create(:candidate, name: "Drake") # Candidate with zero votes, sad but true
      end

      it "returns all candidates including those with zero votes" do
        expect(fetch_results.size).to eq(3)
      end

      it "includes high vote candidate name" do
        result_names = fetch_results.map { |result| result[:name] }
        expect(result_names).to include("Kendrick Lamar")
      end

      it "includes low vote candidate name" do
        result_names = fetch_results.map { |result| result[:name] }
        expect(result_names).to include("Eminem")
      end

      it "includes zero vote candidate name" do
        result_names = fetch_results.map { |result| result[:name] }
        expect(result_names).to include("Drake")
      end

      it "returns correct vote count for high vote candidate" do
        expect(votes_by_name["Kendrick Lamar"][:votes]).to eq(3)
      end

      it "returns correct vote count for low vote candidate" do
        expect(votes_by_name["Eminem"][:votes]).to eq(1)
      end

      it "returns correct vote count for zero vote candidate" do
        expect(votes_by_name["Drake"][:votes]).to eq(0)
      end

      it "orders results by vote count in descending order" do
        expect(fetch_results.map { |result| result[:votes] }).to eq([3, 1, 0])
      end

      it "includes name key in each result" do
        expect(fetch_results).to all(have_key(:name))
      end

      it "includes votes key in each result" do
        expect(fetch_results).to all(have_key(:votes))
      end
    end

    context "when multiple candidates have the same vote count" do
      let!(:candidate_a) { create(:candidate, name: "Artist A") }
      let!(:candidate_b) { create(:candidate, name: "Artist B") }
      let(:users) { create_list(:user, 2) }

      before do
        users.each do |user|
          create(:vote, user: user, candidate: candidate_a)
          create(:vote, user: user, candidate: candidate_b)
        end
      end

      it "includes both tied candidates in results" do
        expect(fetch_results.map { |result| result[:name] }).to contain_exactly("Artist A", "Artist B")
      end

      it "returns correct vote count for first tied candidate" do
        votes_by_name = fetch_results.index_by { |result| result[:name] }
        expect(votes_by_name["Artist A"][:votes]).to eq(2)
      end

      it "returns correct vote count for second tied candidate" do
        votes_by_name = fetch_results.index_by { |result| result[:name] }
        expect(votes_by_name["Artist B"][:votes]).to eq(2)
      end
    end
  end
end
