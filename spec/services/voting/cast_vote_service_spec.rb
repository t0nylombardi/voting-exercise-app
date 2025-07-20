require "rails_helper"

RSpec.describe Voting::CastVoteService do
  subject(:service) { described_class.new(user:, candidate_name:) }

  let(:user) { create(:user) }
  let(:candidate_name) { "John Doe" }

  describe ".call" do
    it "creates a new instance and calls it" do
      expect(described_class).to receive(:new).with(user:, candidate_name:).and_call_original
      expect_any_instance_of(described_class).to receive(:call)

      described_class.call(user:, candidate_name:)
    end
  end

  describe "#call" do
    context "when user has already voted" do
      before { allow(user).to receive(:voted?).and_return(true) }

      it "returns failure result" do
        result = service.call
        expect(result.success?).to be false
      end

      it "returns 'Already voted' error message" do
        result = service.call
        expect(result.error).to eq("Already voted")
      end

      it "does not attempt to resolve candidate" do
        expect(service).not_to receive(:resolve_candidate)
        service.call
      end
    end

    context "when user has not voted yet" do
      before { allow(user).to receive(:voted?).and_return(false) }

      context "when candidate resolution fails" do
        before do
          allow(service).to receive(:resolve_candidate).and_return({error: "Some error"})
        end

        it "returns failure result" do
          result = service.call
          expect(result.success?).to be false
        end

        it "returns the resolution error message" do
          result = service.call
          expect(result.error).to eq("Some error")
        end

        it "does not create a vote" do
          expect { service.call }.not_to change(Vote, :count)
        end
      end

      context "when candidate resolution succeeds" do
        let(:candidate) { create(:candidate, name: "John Doe", votes_count: 5) }

        before do
          allow(service).to receive(:resolve_candidate).and_return(candidate)
        end

        it "creates a vote record" do
          expect { service.call }.to change(Vote, :count).by(1)
        end

        it "creates vote with correct user id" do
          service.call
          vote = Vote.last
          expect(vote.user_id).to eq(user.id)
        end

        it "creates vote with correct candidate id" do
          service.call
          vote = Vote.last
          expect(vote.candidate_id).to eq(candidate.id)
        end

        it "increments candidate votes count" do
          expect(candidate).to receive(:increment!).with(:votes_count)
          service.call
        end

        it "returns success result" do
          result = service.call
          expect(result.success?).to be true
        end

        it "returns the candidate in result" do
          result = service.call
          expect(result.candidate).to eq(candidate)
        end
      end
    end
  end

  describe "#resolve_candidate" do
    let(:matcher) { double("CandidateMatcherService") }

    before do
      allow(Voting::CandidateMatcherService).to receive(:call).with("John Doe").and_return(matcher)
    end

    context "when fuzzy match suggestion is found" do
      before do
        allow(service).to receive(:check_fuzzy_match).with(matcher).and_return({error: "Did you mean 'Jane Doe'?"})
      end

      it "returns the fuzzy match suggestion" do
        result = service.send(:resolve_candidate)
        expect(result).to eq({error: "Did you mean 'Jane Doe'?"})
      end

      it "does not check for existing candidates" do
        expect(matcher).not_to receive(:existing?)
        service.send(:resolve_candidate)
      end
    end

    context "when no fuzzy match suggestion" do
      before do
        allow(service).to receive(:check_fuzzy_match).with(matcher).and_return(nil)
      end

      context "when candidate exists" do
        let(:existing_candidate) { create(:candidate, name: "John Doe") }

        before do
          allow(matcher).to receive(:existing?).and_return(true)
          allow(matcher).to receive(:best_match).and_return(existing_candidate)
        end

        it "returns the existing candidate" do
          result = service.send(:resolve_candidate)
          expect(result).to eq(existing_candidate)
        end

        it "does not attempt write-in handling" do
          expect(service).not_to receive(:handle_write_in_candidate)
          service.send(:resolve_candidate)
        end
      end

      context "when candidate does not exist" do
        let(:write_in_candidate) { create(:candidate, name: "John Doe") }

        before do
          allow(matcher).to receive(:existing?).and_return(false)
          allow(service).to receive(:handle_write_in_candidate).and_return(write_in_candidate)
        end

        it "returns the write-in candidate" do
          result = service.send(:resolve_candidate)
          expect(result).to eq(write_in_candidate)
        end
      end
    end
  end

  describe "#check_fuzzy_match" do
    let(:matcher) { double("CandidateMatcherService") }
    let(:candidate) { create(:candidate, name: "Jane Doe") }

    before do
      allow(matcher).to receive(:best_match).and_return(candidate)
      stub_const("Voting::CandidateMatcherService::SIMILARITY_THRESHOLD", 0.95)
    end

    context "when match score is in suggestion range" do
      before do
        allow(matcher).to receive(:best_match_score).and_return(0.90)
      end

      it "returns suggestion hash" do
        result = service.send(:check_fuzzy_match, matcher)
        expect(result).to eq({error: "Did you mean 'Jane Doe'?"})
      end
    end

    context "when match score is below suggestion range" do
      before do
        allow(matcher).to receive(:best_match_score).and_return(0.80)
      end

      it "returns nil" do
        result = service.send(:check_fuzzy_match, matcher)
        expect(result).to be_nil
      end
    end

    context "when match score is above suggestion range" do
      before do
        allow(matcher).to receive(:best_match_score).and_return(0.96)
      end

      it "returns nil" do
        result = service.send(:check_fuzzy_match, matcher)
        expect(result).to be_nil
      end
    end

    context "when match score is exactly at lower bound" do
      before do
        allow(matcher).to receive(:best_match_score).and_return(0.85)
      end

      it "returns suggestion hash" do
        result = service.send(:check_fuzzy_match, matcher)
        expect(result).to eq({error: "Did you mean 'Jane Doe'?"})
      end
    end

    context "when match score is exactly at upper bound" do
      before do
        allow(matcher).to receive(:best_match_score).and_return(0.95)
      end

      it "returns suggestion hash" do
        result = service.send(:check_fuzzy_match, matcher)
        expect(result).to eq({error: "Did you mean 'Jane Doe'?"})
      end
    end
  end

  describe "#handle_write_in_candidate" do
    context "when validation passes" do
      let(:new_candidate) { create(:candidate, name: "John Doe") }

      before do
        allow(service).to receive(:validate_write_in_constraints).and_return(nil)
        allow(service).to receive(:create_write_in_candidate).and_return(new_candidate)
      end

      it "returns the new candidate" do
        result = service.send(:handle_write_in_candidate)
        expect(result).to eq(new_candidate)
      end
    end

    context "when validation fails" do
      before do
        allow(service).to receive(:validate_write_in_constraints).and_return("Too many candidates")
      end

      it "returns error hash" do
        result = service.send(:handle_write_in_candidate)
        expect(result).to eq({error: "Too many candidates"})
      end

      it "does not attempt to create candidate" do
        expect(service).not_to receive(:create_write_in_candidate)
        service.send(:handle_write_in_candidate)
      end
    end
  end

  describe "#normalize_name" do
    it "strips leading and trailing whitespace" do
      result = service.send(:normalize_name, "  john doe  ")
      expect(result).to eq("John Doe")
    end

    it "converts all caps to title case" do
      result = service.send(:normalize_name, "JANE SMITH")
      expect(result).to eq("Jane Smith")
    end

    it "converts mixed case to title case" do
      result = service.send(:normalize_name, "bOb JoNes")
      expect(result).to eq("Bob Jones")
    end
  end

  describe "#validate_write_in_constraints" do
    context "when candidate limit is reached" do
      before { create_list(:candidate, 10) }

      it "returns 'Too many candidates' error" do
        result = service.send(:validate_write_in_constraints)
        expect(result).to eq("Too many candidates")
      end
    end

    context "when user already has a write-in" do
      before { user.update!(write_in: create(:candidate)) }

      it "returns 'Already wrote in a candidate' error" do
        result = service.send(:validate_write_in_constraints)
        expect(result).to eq("Already wrote in a candidate")
      end
    end

    context "when constraints are satisfied" do
      before { create_list(:candidate, 5) } # Under the limit

      it "returns nil" do
        result = service.send(:validate_write_in_constraints)
        expect(result).to be_nil
      end
    end
  end

  describe "#create_write_in_candidate" do
    it "creates one new candidate record" do
      expect { service.send(:create_write_in_candidate) }
        .to change(Candidate, :count).by(1)
    end

    it "creates candidate with normalized name" do
      service.send(:create_write_in_candidate)
      expect(Candidate.last.name).to eq("John Doe")
    end

    it "associates candidate as user's write-in" do
      service.send(:create_write_in_candidate)
      expect(user.reload.write_in.name).to eq("John Doe")
    end

    it "returns a Candidate instance" do
      result = service.send(:create_write_in_candidate)
      expect(result).to be_a(Candidate)
    end

    it "returns candidate with correct name" do
      result = service.send(:create_write_in_candidate)
      expect(result.name).to eq("John Doe")
    end
  end

  describe "integration scenarios" do
    context "exact match scenario" do
      let!(:candidate) { create(:candidate, name: "John Doe", votes_count: 3) }

      before { described_class.call(user:, candidate_name:) }

      it "returns success result" do
        expect(user.voted?).to be true
      end

      it "returns the existing candidate" do
        expect(user.votes.first.candidate).to eq(candidate)
      end

      it "marks user as voted" do
        expect(user.reload.voted?).to be true
      end

      it "increments candidate vote count" do
        expect(candidate.reload.votes_count).to eq(5)
      end
    end

    context "write-in scenario" do
      it "returns success result" do
        result = described_class.call(user:, candidate_name: "New Candidate")
        expect(result.success?).to be true
      end

      it "returns candidate with correct name" do
        result = described_class.call(user:, candidate_name: "New Candidate")
        expect(result.candidate.name).to eq("New Candidate")
      end

      it "associates write-in with user" do
        described_class.call(user:, candidate_name: "New Candidate")
        expect(user.reload.write_in.name).to eq("New Candidate")
      end

      it "marks user as voted" do
        described_class.call(user:, candidate_name: "New Candidate")
        expect(user.reload.voted?).to be true
      end
    end

    context "fuzzy match scenario" do
      let!(:candidate) { create(:candidate, name: "Kendrick Lamar") }

      before do
        # Mock the matcher service to simulate fuzzy matching behavior
        matcher = double("CandidateMatcherService")
        allow(Voting::CandidateMatcherService).to receive(:call).and_return(matcher)
        allow(matcher).to receive(:best_match_score).and_return(0.98) # Above threshold
        allow(matcher).to receive(:existing?).and_return(true)
        allow(matcher).to receive(:best_match).and_return(candidate)
      end

      it "returns success result" do
        result = described_class.call(user:, candidate_name: "Kendrik Lamar")
        expect(result.success?).to be true
      end

      it "returns the fuzzy matched candidate" do
        result = described_class.call(user:, candidate_name: "Kendrik Lamar")
        expect(result.candidate).to eq(candidate)
      end
    end
  end
end
