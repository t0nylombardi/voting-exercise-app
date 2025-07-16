import { Routes, Route, Navigate } from "react-router-dom";
import Layout from "./components/layout/Layout";
import RequiredAuth from "./components/auth/RequireAuth";
import { LoginPage, VotePage, ResultsPage } from "./pages";
import type { User } from "./types/userType";
import "./styles/App.css";

export default function App() {
  return (
    <Routes>
      <Route element={<Layout />}>
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

        <Route element={<RequiredAuth />}>
          <Route path="/vote" element={<VotePage />} />
          <Route path="/results" element={<ResultsPage />} />
        </Route>

        <Route
          path="*"
          element={
            JSON.parse(localStorage.getItem("user") || "null") ? (
              <Navigate to="/vote" replace />
            ) : (
              <Navigate to="/login" replace />
            )
          }
        />
      </Route>
    </Routes>
  );
}
