import Button from "../components/ui/Button/Button";
import TextInput from "../components/ui/Form/TextInput";
import { type User } from "../types/userType";

const LoginPage = ({ onLogin }: { onLogin: (user: User) => void }) => {
  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const form = e.currentTarget;
    const email = form.email.value;
    const zip = form.zip.value;
    const user: User = { email, zip };
    onLogin(user);
  };

  return (
    <div className="flex items-right justify-start min-h-screen m-20">
      <div className="bg-white p-6 w-[30rem]">
        <h2 className="text-4xl mb-4">Sign in to vote</h2>
        <form onSubmit={handleSubmit}>
          <TextInput label="Email" name="email" type="email" required />
          <TextInput
            label="Password"
            name="password"
            type="password"
            required
          />
          <TextInput label="Zip Code" name="zip" type="text" required />
          <Button type="submit">Sign in</Button>
        </form>
      </div>
    </div>
  );
};

export default LoginPage;
