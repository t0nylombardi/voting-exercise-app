import { type User } from "../types/userType";

const LoginPage = ({ onLogin }: { onLogin: (user: User) => void }) => {
  return (
    <div className="flex items-center justify-center min-h-screen">
      <div className="bg-white p-6 w-96">
        <h2 className="text-2xl font-bold mb-4">Sign in to vote</h2>
        <form
          onSubmit={(e) => {
            e.preventDefault();
            const email = (e.target as HTMLFormElement).email.value;
            const zip = (e.target as HTMLFormElement).zip.value;
            const user: User = { email, zip };
            onLogin(user);
          }}
        >
          <div className="mb-4">
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Email
            </label>
            <input
              type="email"
              name="email"
              required
              className="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
          <div className="mb-4">
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Zip Code
            </label>
            <input
              type="text"
              name="zip"
              required
              className="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
          <button
            type="submit"
            className="w-full px-4 py-2 text-white bg-blue-500 rounded hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            Login
          </button>
        </form>
      </div>
    </div>
  );
};

export default LoginPage;
