import { useEffect, type ReactElement } from "react";
import MainWrapper from "../components/layout/MainWrapper";
import CandidateList from "../components/vote/CandidateList";
import WriteInForm from "../components/vote/WriteInForm";
import VoteFeedback from "../components/vote/VoteFeedback";
import { castVote } from "../services/voteService";
import { fetchCandidates } from "../services/resultsService";
import { useVoteState } from "../hooks/useVoteState";

const VotePage = (): ReactElement => {
  const {
    candidates,
    setCandidates,
    selectedCandidate,
    setSelectedCandidate,
    writeIn,
    setWriteIn,
    loading,
    setLoading,
    votingMode,
    setVotingMode,
    globalError,
    setGlobalError,
    writeInError,
    setWriteInError,
    success,
    setSuccess,
  } = useVoteState();

  useEffect(() => {
    fetchCandidates()
      .then(setCandidates)
      .catch(() => setGlobalError("Unable to load candidates."));
  }, [setCandidates, setGlobalError]);

  useEffect(() => {
    if (success) {
      setSelectedCandidate("");
      setWriteIn("");
    }
  }, [success, setSelectedCandidate, setWriteIn]);

  const handleVote = async (e: React.FormEvent) => {
    e.preventDefault();

    const candidateName = getCandidateName();
    if (!candidateName) return;

    beginVote();

    try {
      await submitVote(candidateName);
      await refreshCandidates();
      markVoteSuccessful();
    } catch (err) {
      handleVoteError(err);
    } finally {
      finalizeVote();
    }
  };

  const getCandidateName = (): string | null => {
    return selectedCandidate || writeIn || null;
  };

  const beginVote = () => {
    setLoading(true);
    setGlobalError(null);
    setWriteInError(null);
  };

  const submitVote = async (name: string) => {
    await castVote(name);
  };

  const refreshCandidates = async () => {
    const updated = await fetchCandidates();
    setCandidates(updated);
  };

  const markVoteSuccessful = () => {
    setSuccess(true);
  };

  const handleVoteError = (err: unknown) => {
    const message =
      err instanceof Error ? err.message : "Something went wrong.";
    if (votingMode === "write-in") {
      setWriteInError(message);
    } else {
      setGlobalError(message);
    }
  };

  const finalizeVote = () => {
    setLoading(false);
    setVotingMode(null);
  };

  return (
    <MainWrapper>
      <div className="w-[45rem]">
        <h1 className="text-6xl leading-[1.5] mb-12">Cast your vote today!</h1>

        <form onSubmit={handleVote} className="space-y-12 w-full">
          <CandidateList
            candidates={candidates}
            selected={selectedCandidate}
            loading={loading && votingMode === "existing"}
            success={success}
            onSelect={(name) => {
              setSelectedCandidate(name);
              setWriteIn("");
            }}
            onVoteClick={() => setVotingMode("existing")}
          />

          <VoteFeedback error={globalError} success={success} />

          <hr className="border-t-2 border-black/50" />

          <WriteInForm
            value={writeIn}
            onChange={(val) => {
              setWriteIn(val);
              setSelectedCandidate("");
            }}
            loading={loading && votingMode === "write-in"}
            success={success}
            error={writeInError}
            onVoteClick={() => setVotingMode("write-in")}
          />
        </form>
      </div>
    </MainWrapper>
  );
};

export default VotePage;
