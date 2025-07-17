import { useState, type ReactElement } from "react";
import MainWrapper from "../components/layout/MainWrapper";
import TextInput from "../components/ui/Form/TextInput";
import Button from "../components/ui/Button/Button";
import clsx from "clsx";

const VotePage = (): ReactElement => {
  const [selectedCandidate, setSelectedCandidate] = useState("");
  const [writeIn, setWriteIn] = useState("");

  const candidates = [
    // TODO: fetch from backend
    "Cindy and The Scintillators",
    "Alice Wonderland",
    "DJ Electra",
    "MC Tempo",
  ];

  const handleVote = (e: React.FormEvent) => {
    e.preventDefault();
    // submit vote logic
    console.log("Voted for:", selectedCandidate || writeIn);
  };

  return (
    <MainWrapper>
      <h1 className="text-6xl leading-[1.5] mb-12">Cast your vote today!</h1>

      <form onSubmit={handleVote} className="space-y-6 w-full">
        <fieldset className="space-y-3">
          {candidates.map((name) => (
            <label key={name} className="flex items-center text-2xl space-x-4">
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
                  "appearance-none w-10 h-10 my-4 rounded-full border-4 border-black/50",
                  selectedCandidate === name && "bg-black/50"
                )}
              />
              <span>{name}</span>
            </label>
          ))}
          <Button type="submit" className=" w-1/4 my-4 py-4 text-4xl">
            Vote
          </Button>
        </fieldset>

        <hr className="border-t border-black/50 border-2 my-12" />

        <div>
          <label htmlFor="write-in" className="block text-2xl mb-6">
            Or, add a new candidate:
          </label>
          <div className="flex flex-row items-center gap-4">
            <TextInput
              name="write-in"
              value={writeIn}
              onChange={(e) => {
                setWriteIn(e.target.value);
                setSelectedCandidate("");
              }}
              placeholder="Enter name..."
              className="flex-1 py-5 px-4 text-2xl border-4 border-black/50 rounded-xl"
            />
            <Button type="submit" className="text-medium w-32 py-6 text-2xl">
              Vote
            </Button>
          </div>
        </div>
      </form>
    </MainWrapper>
  );
};

export default VotePage;
