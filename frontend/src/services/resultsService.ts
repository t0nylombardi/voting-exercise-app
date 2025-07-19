export interface CandidateResult {
  name: string;
  votes: number;
}

export async function fetchCandidates(): Promise<CandidateResult[]> {
  const res = await fetch("http://localhost:3000/api/v1/results", {
    method: "GET",
    credentials: "include",
  });

  if (!res.ok) {
    throw new Error("Failed to fetch candidates.");
  }

  return res.json();
}
