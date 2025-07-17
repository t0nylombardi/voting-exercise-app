import { useState, type ReactElement } from "react";
import MainWrapper from "../components/layout/MainWrapper";
import TextInput from "../components/ui/Form/TextInput";
import Button from "../components/ui/Button/Button";
import clsx from "clsx";

const VotePage = (): ReactElement => {
  const [selectedCandidate, setSelectedCandidate] = useState("");
  const [writeIn, setWriteIn] = useState("");

  const candidates = [
    "Cindy and The Scintillators",
    "Alice Wonderland",
    "DJ Electra",
    "MC Tempo",
  ];

  const handleVote = (e: React.FormEvent) => {
    e.preventDefault();
    console.log("Voted for:", selectedCandidate || writeIn);
  };

  return (
    <MainWrapper>
      <div className="w-[45rem]">
        <h1 className="text-6xl leading-[1.5] mb-12">Cast your vote today!</h1>

        <form onSubmit={handleVote} className="space-y-12 w-full">
          {/* Candidate Selection */}
          <fieldset className="space-y-4">
            <legend className="sr-only">Select a candidate</legend>
            {candidates.map((name) => (
              <label
                key={name}
                className="flex items-center text-2xl space-x-4 cursor-pointer"
              >
                <input
                  type="radio"
                  name="vote"
                  value={name}
                  checked={selectedCandidate === name}
                  onChange={() => {
                    setSelectedCandidate(name);
                    setWriteIn("");
                  }}
                  className={clsx(
                    "appearance-none w-6 h-6 rounded-full border-4 border-black/70",
                    "focus-visible:outline focus-visible:outline-4 focus-visible:outline-offset-2 focus-visible:outline-black",
                    selectedCandidate === name && "bg-black"
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
            >
              Vote
            </Button>
          </fieldset>

          <hr className="border-t-2 border-black/50" />

          <div>
            <label htmlFor="write-in" className="block text-2xl mb-4">
              Or, add a new candidate:
            </label>
            <p id="write-in-desc" className="text-base mb-4 text-gray-600">
              You may only write in one new candidate. This will automatically
              cast your vote.
            </p>
            <div className="flex flex-row items-center gap-4">
              <TextInput
                id="write-in"
                name="write-in"
                value={writeIn}
                onChange={(e) => {
                  setWriteIn(e.target.value);
                  setSelectedCandidate("");
                }}
                placeholder="Enter name..."
                className="flex-1 py-5 px-4 text-2xl border-4 border-black/50 rounded-xl"
                aria-describedby="write-in-desc"
              />
              <Button
                type="submit"
                className="text-medium w-32 py-6 text-2xl"
                aria-label="Submit vote for new write-in candidate"
              >
                Vote
              </Button>
            </div>
          </div>
        </form>
      </div>
    </MainWrapper>
  );
};

export default VotePage;
