import { Outlet, useNavigate } from "react-router-dom";
import { useEffect, useState } from "react";
import NavBar from "./NavBar";
import type { User } from "../../types/userType";

export default function Layout() {
  const navigate = useNavigate();
  const [user, setUser] = useState<User | null>(() => {
    const saved = localStorage.getItem("user");
    return saved ? JSON.parse(saved) : null;
  });

  const isLoggedIn = Boolean(user);

  const logout = () => {
    localStorage.removeItem("user");
    setUser(null);
    navigate("/login");
  };

  useEffect(() => {
    if (!isLoggedIn && window.location.pathname !== "/login") {
      navigate("/login");
    }
  }, [isLoggedIn, navigate]);

  return (
    <>
      <NavBar logout={logout} isLoggedIn={isLoggedIn} user={user} />
      <Outlet />
    </>
  );
}
