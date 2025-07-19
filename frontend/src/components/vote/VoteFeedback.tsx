interface VoteFeedbackProps {
  error: string | null;
  success: boolean;
}

const VoteFeedback = ({ error, success }: VoteFeedbackProps) => (
  <>
    {error && <p className="text-red-600 text-lg mb-4">{error}</p>}
    {success && (
      <p className="text-green-600 text-lg mb-4">Vote recorded successfully!</p>
    )}
  </>
);

export default VoteFeedback;
