import { Routes, Route, Navigate, Outlet, useNavigate } from "react-router-dom";
import { useEffect, useState } from "react";
import NavBar from "./components/layout/NavBar";
import { LoginPage, VotePage, ResultsPage } from "./pages";
import type { User } from "./types/userType";
import "./styles/App.css";

function AppContent() {
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
      <NavBar
        logout={logout}
        isLoggedIn={isLoggedIn}
        user={user ?? { email: "", zip: "" }}
      />
      <Outlet />
    </>
  );
}

// Protected route wrapper
function ProtectedRoute({ isLoggedIn }: { isLoggedIn: boolean }) {
  return isLoggedIn ? <Outlet /> : <Navigate to="/login" replace />;
}

export default function App() {
  const user = JSON.parse(localStorage.getItem("user") || "null");
  const isLoggedIn = Boolean(user);

  return (
    <Routes>
      <Route element={<AppContent />}>
        <Route
          path="/login"
          element={
            <LoginPage
              onLogin={(u: User) => {
                localStorage.setItem("user", JSON.stringify(u));
                window.location.replace("/vote");
              }}
            />
          }
        />
        <Route element={<ProtectedRoute isLoggedIn={isLoggedIn} />}>
          <Route path="/vote" element={<VotePage />} />
          <Route path="/results" element={<ResultsPage />} />
        </Route>
        <Route
          path="*"
          element={<Navigate to={isLoggedIn ? "/vote" : "/login"} replace />}
        />
      </Route>
    </Routes>
  );
}
