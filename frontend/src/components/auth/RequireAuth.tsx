import { Navigate, Outlet } from "react-router-dom";

export default function RequiredAuth() {
  const user = JSON.parse(localStorage.getItem("user") || "null");
  const isLoggedIn = Boolean(user);

  return isLoggedIn ? <Outlet /> : <Navigate to="/login" replace />;
}
