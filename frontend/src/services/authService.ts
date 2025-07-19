import type { User } from "../types/userType";
import { apiFetch } from "./api";

export async function login(payload: User): Promise<User> {
  const data = await apiFetch<{ user: User }>("/login", {
    method: "POST",
    credentials: "include",
    body: payload as unknown as Record<string, unknown>,
  });

  return data.user;
}
