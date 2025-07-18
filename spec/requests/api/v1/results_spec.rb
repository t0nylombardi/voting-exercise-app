# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Results", type: :request do
  describe "GET /api/v1/results" do
    subject(:get_results) { get "/api/v1/results" }

    context "when there are no candidates" do
      it "returns HTTP 200" do
        get_results
        expect(response).to have_http_status(:ok)
      end

      it "returns an empty array" do
        get_results
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context "when candidates exist with votes" do
      let(:users) { create_list(:user, 3) }

      before do
        setup_basic_vote_distribution
      end

      it "returns HTTP 200" do
        get_results
        expect(response).to have_http_status(:ok)
      end

      it "returns all candidates in JSON" do
        get_results
        json = JSON.parse(response.body)
        expect(json.map { |c| c["name"] }).to include("Artist A", "Artist B")
      end

      it "includes vote counts for artist a" do
        get_results
        json = JSON.parse(response.body)
        votes = json.index_by { |c| c["name"] }
        expect(votes["Artist A"]["votes"]).to eq(2)
      end

      it "includes vote counts for artist b" do
        get_results
        json = JSON.parse(response.body)
        votes = json.index_by { |c| c["name"] }
        expect(votes["Artist B"]["votes"]).to eq(1)
      end
    end

    context "when a candidate has zero votes" do
      let(:json) { JSON.parse(response.body) }
      let(:result) { json.find { |c| c["name"] == "Ghost" } }

      before do
        create(:candidate, name: "Ghost")
        get_results
      end

      it "returns HTTP 200" do
        expect(response).to have_http_status(:ok)
      end

      it "includes the candidate with zero votes" do
        expect(result).not_to be_nil
      end

      it "returns candidate with 0 votes" do
        expect(result["votes"]).to eq(0)
      end
    end
  end
end
