export async function castVote(candidate_name: string) {
  const res = await fetch("http://localhost:3000/api/v1/vote", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    credentials: "include",
    body: JSON.stringify({ candidate_name }),
  });

  const data = await res.json();

  if (!res.ok) throw new Error(data.error || "Vote failed");

  return data; // should return message, candidate_name
}
