import * as React from "react";
import MainWrapper from "../components/layout/MainWrapper";

function ResultsPage(): React.ReactElement {
  const candidates = [
    { id: 1, name: "Eminem", votes: Math.floor(Math.random() * 100) },
    { id: 2, name: "Notorious B.I.G.", votes: Math.floor(Math.random() * 100) },
    { id: 3, name: "Kendrick Lamar", votes: Math.floor(Math.random() * 100) },
    { id: 4, name: "Lil Wayne", votes: Math.floor(Math.random() * 100) },
    { id: 5, name: "J. Cole", votes: Math.floor(Math.random() * 100) },
    { id: 6, name: "Nas", votes: Math.floor(Math.random() * 100) },
    { id: 7, name: "Jay-Z", votes: Math.floor(Math.random() * 100) },
    { id: 8, name: "Rakim", votes: Math.floor(Math.random() * 100) },
    { id: 9, name: "Method Man", votes: Math.floor(Math.random() * 100) },
    { id: 10, name: "Kanye West", votes: Math.floor(Math.random() * 0) },
    { id: 11, name: "Drake", votes: Math.floor(Math.random() * 5) },
  ];

  return (
    <MainWrapper>
      <div className="my-8">
        <h1 className="text-6xl">Results</h1>
      </div>

      <div className="mt-12 divide-y-4 divide-black/50 border-y-4 border-black/50">
        {candidates
          .sort((a, b) => b.votes - a.votes)
          .map((candidate) => (
            <div
              key={candidate.id}
              className="flex justify-between text-2xl px-4 py-8"
            >
              <span className="text-black">{candidate.name}</span>
              <span className="text-black">{candidate.votes}</span>
            </div>
          ))}
      </div>
    </MainWrapper>
  );
}

export default ResultsPage;
