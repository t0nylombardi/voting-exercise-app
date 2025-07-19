import { useEffect, useState } from "react";
import { fetchCandidates, type CandidateResult } from "../services/resultsService";

export function useResults() {
  const [results, setResults] = useState<CandidateResult[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchCandidates()
      .then(setResults)
      .catch(() => setError("Could not load results."))
      .finally(() => setLoading(false));
  }, []);

  return { results, loading, error };
}
