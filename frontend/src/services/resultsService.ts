import { apiFetch } from "./api";

export interface CandidateResult {
  name: string;
  votes: number;
}

export async function fetchCandidates() {
  return apiFetch<Array<CandidateResult>>("/results");
}
