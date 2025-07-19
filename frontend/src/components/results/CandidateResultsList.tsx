import { type CandidateResult } from "../../services/resultsService";

interface Props {
  candidates: CandidateResult[];
}

const CandidateResultsList = ({ candidates }: Props) => {
  const sorted = [...candidates].sort((a, b) => b.votes - a.votes);

  return (
    <div className="mt-12 divide-y-4 divide-black/50 border-y-4 border-black/50">
      {sorted.map((candidate, idx) => (
        <div key={idx} className="flex justify-between text-2xl px-4 py-8">
          <span className="text-black">{candidate.name}</span>
          <span className="text-black">{candidate.votes}</span>
        </div>
      ))}
    </div>
  );
};

export default CandidateResultsList;
