import { useState } from "react";
import { login } from "../services/authService";
import { type User } from "../types/userType";
import Button from "../components/ui/Button/Button";
import TextInput from "../components/ui/Form/TextInput";
import MainWrapper from "../components/layout/MainWrapper";

const LoginPage = ({ onLogin }: { onLogin: (user: User) => void }) => {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    const form = e.currentTarget;
    const email = form.email.value;
    const zip = form.zip.value;
    const password = form.password.value;

    try {
      const user = await login({ email, password, zip_code: zip });
      onLogin(user);
    } catch (err: unknown) {
      setError(
        err instanceof Error ? err.message : "An unexpected error occurred"
      );
    } finally {
      setLoading(false);
    }
  };

  return (
    <MainWrapper>
      <h2 className="text-4xl mb-6">Sign in to vote</h2>

      <form onSubmit={handleSubmit} noValidate>
        <TextInput
          label="Email"
          name="email"
          type="email"
          required
          disabled={loading}
        />
        <TextInput
          label="Password"
          name="password"
          type="password"
          required
          disabled={loading}
        />
        <TextInput
          label="Zip Code"
          name="zip"
          type="text"
          required
          disabled={loading}
        />

        {error && <p className="text-red-600 text-sm mt-2">{error}</p>}

        <Button type="submit" loading={loading} className="my-4">
          Sign in
        </Button>
      </form>
    </MainWrapper>
  );
};

export default LoginPage;
