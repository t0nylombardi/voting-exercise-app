import clsx from "clsx";
import Button from "../ui/Button/Button";

interface CandidateListProps {
  candidates: { name: string }[];
  selected: string;
  loading: boolean;
  success: boolean;
  onSelect: (name: string) => void;
  onVoteClick: () => void;
}

const CandidateList = ({
  candidates,
  selected,
  loading,
  success,
  onSelect,
  onVoteClick,
}: CandidateListProps) => (
  <fieldset className="space-y-4" disabled={loading || success}>
    <legend className="sr-only">Select a candidate</legend>

    {candidates.map(({ name }) => (
      <label
        key={name}
        className="flex items-center text-2xl space-x-4 cursor-pointer mb-6"
      >
        <input
          type="radio"
          name="vote"
          value={name}
          checked={selected === name}
          onChange={() => onSelect(name)}
          className={clsx(
            "appearance-none w-10 h-10 rounded-full border-4 border-black/70",
            "focus-visible:outline focus-visible:outline-4 focus-visible:outline-offset-2 focus-visible:outline-black",
            selected === name && "bg-black"
          )}
          aria-label={`Vote for ${name}`}
        />
        <span>{name}</span>
      </label>
    ))}

    <Button
      type="submit"
      className="w-1/3 my-4 py-4 text-4xl"
      aria-label="Submit vote for selected candidate"
      loading={loading}
      disabled={loading || success}
      onClick={onVoteClick}
    >
      Vote
    </Button>
  </fieldset>
);

export default CandidateList;
