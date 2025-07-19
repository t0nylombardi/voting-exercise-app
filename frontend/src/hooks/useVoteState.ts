import { useState } from "react";
import { type CandidateResult } from "../services/resultsService";

type VotingMode = "write-in" | "existing" | null;

export function useVoteState() {
  const [candidates, setCandidates] = useState<CandidateResult[]>([]);
  const [selectedCandidate, setSelectedCandidate] = useState("");
  const [writeIn, setWriteIn] = useState("");
  const [loading, setLoading] = useState(false);
  const [votingMode, setVotingMode] = useState<VotingMode>(null);
  const [globalError, setGlobalError] = useState<string | null>(null);
  const [writeInError, setWriteInError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);

  return {
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
  };
}
