import TextInput from "../ui/Form/TextInput";
import Button from "../ui/Button/Button";
import VoteFeedback from "./VoteFeedback";

interface WriteInFormProps {
  value: string;
  onChange: (val: string) => void;
  loading: boolean;
  success: boolean;
  error: string | null;
  onVoteClick: () => void;
}

const WriteInForm = ({
  value,
  onChange,
  loading,
  success,
  error,
  onVoteClick,
}: WriteInFormProps) => (
  <div>
    <label htmlFor="write-in" className="block text-2xl mb-4">
      Or, add a new candidate:
    </label>
    <p id="write-in-desc" className="text-base mb-4 text-gray-600">
      You may only write in one new candidate. This will automatically cast your
      vote.
    </p>
    <div className="flex flex-row items-center gap-4 my-12">
      <TextInput
        id="write-in"
        name="write-in"
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder="Enter name..."
        disabled={loading || success}
        className="flex-1 py-5 px-4 mb-0 text-2xl border-4 border-black/50 rounded-xl"
        aria-describedby="write-in-desc"
      />
      <Button
        type="submit"
        className="text-medium w-32 py-6 text-2xl"
        aria-label="Submit vote for new write-in candidate"
        loading={loading}
        disabled={loading || success}
        onClick={onVoteClick}
      >
        Vote
      </Button>
    </div>
    <VoteFeedback error={error} success={success} />
  </div>
);

export default WriteInForm;
