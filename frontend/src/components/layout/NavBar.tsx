import { type User } from "../../types/userType";
import Button from "../ui/Button/Button";

interface NavBarProps {
  user: User | null;
  isLoggedIn: boolean;
  logout: () => void;
}

export default function NavBar({ user, isLoggedIn, logout }: NavBarProps) {
  return (
    <nav className="flex items-center justify-between px-6 py-4 border-4 border-black/50">
      <h1 className="text-xl flex-1">VOTE.WEBSITE</h1>

      {isLoggedIn && user && (
        <div className="flex items-center gap-4 whitespace-nowrap">
          <span className="text-lg text-right block">
            Signed in as <span className="font-medium">{user.email}</span>
          </span>
          <Button onClick={logout} className="w-auto text-sm py-4 px-4">
            Logout
          </Button>
        </div>
      )}
    </nav>
  );
}
