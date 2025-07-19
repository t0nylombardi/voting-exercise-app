import * as React from "react";
import MainWrapper from "../components/layout/MainWrapper";
import CandidateResultsList from "../components/results/CandidateResultsList";
import { useResults } from "../hooks/useResults";

function ResultsPage(): React.ReactElement {
  const { results, loading, error } = useResults();

  return (
    <MainWrapper>
      <div className="my-8">
        <h1 className="text-6xl">Results</h1>
      </div>

      {loading && <p className="text-xl mt-6">Loading results...</p>}
      {error && <p className="text-red-600 text-xl mt-6">{error}</p>}

      {!loading && !error && <CandidateResultsList candidates={results} />}
    </MainWrapper>
  );
}

export default ResultsPage;
