import type { User } from "../types/userType";

export async function login(payload: User): Promise<User> {
  const res = await fetch("http://localhost:3000/api/v1/login", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    credentials: "include",
    body: JSON.stringify(payload),
  });

  const data = await res.json();

  if (!res.ok) {
    throw new Error(data.error || "Login failed");
  }

  return data.user;
}
