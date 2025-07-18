# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::VotesController, type: :request do
  let(:user) do
    create(:user,
      email: "offkeyandy@outofpitch.io",
      password: "iForgotMyPwdAgain",
      zip_code: "54321")
  end

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "POST /api/v1/vote" do
    context "when voting for an existing candidate" do
      # let!(:candidate) { Candidate.create!(name: "DJ Synth") }

      it "casts a vote successfully" do
        post "/api/v1/vote", params: {candidate_name: "DJ Synth"}

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq("Vote recorded")
        expect(user.reload.voted?).to be true
      end
    end

    context "when user already voted" do
      let!(:candidate) { Candidate.create!(name: "DJ Synth") }

      before do
        Vote.create!(user: user, candidate: candidate)
      end

      it "does not allow multiple votes" do
        post "/api/v1/vote", params: {candidate_name: "DJ Synth"}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to match(/already voted/i)
      end
    end

    context "when writing in a new candidate" do
      it "creates candidate and votes for them" do
        post "/api/v1/vote", params: {candidate_name: "MC Byte"}

        expect(response).to have_http_status(:ok)
        expect(Candidate.find_by(name: "Mc Byte")).to be_present
        expect(user.reload.write_in.name).to eq("Mc Byte")
      end
    end

    context "when trying to add more than one write-in" do
      before do
        candidate = Candidate.create!(name: "DJ Nova")
        user.update!(write_in: candidate)
      end

      it "prevents another write-in" do
        post "/api/v1/vote", params: {candidate_name: "MC Byte"}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to match(/already wrote in/i)
      end
    end

    context "when candidate limit (10) is reached" do
      before do
        10.times { |i| Candidate.create!(name: "Artist #{i}") }
      end

      it "prevents creating a new candidate" do
        post "/api/v1/vote", params: {candidate_name: "MC Byte"}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to match(/too many candidates/i)
      end
    end
  end
end
