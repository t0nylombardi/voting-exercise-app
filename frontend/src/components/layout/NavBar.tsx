import { type User } from "../../types/userType";

interface NavBarProps {
  user: User | null;
  isLoggedIn: boolean;
  logout: () => void;
}

export default function NavBar({ user, isLoggedIn, logout }: NavBarProps) {
  return (
    <nav className="flex items-center justify-between px-6 py-4 border-b border-gray-300 bg-[--color-bg-primary]">
      <h1 className="text-xl">VOTE.WEBSITE</h1>

      {isLoggedIn && user && (
        <div className="flex items-center gap-4">
          <span className="text-[--color-text-secondary]">
            Signed in as <span className="font-medium">{user.email}</span>
          </span>
          <button
            onClick={logout}
            className="px-4 py-2 text-white rounded bg-[--color-danger] hover:bg-[--color-danger-hover] transition"
          >
            Logout
          </button>
        </div>
      )}
    </nav>
  );
}
