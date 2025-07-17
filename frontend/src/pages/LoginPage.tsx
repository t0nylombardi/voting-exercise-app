import Button from "../components/ui/Button/Button";
import TextInput from "../components/ui/Form/TextInput";
import MainWrapper from "../components/layout/MainWrapper";
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
    <MainWrapper>
      <h2 className="text-4xl mb-6">Sign in to vote</h2>
      <form onSubmit={handleSubmit}>
        <TextInput label="Email" name="email" type="email" required />
        <TextInput label="Password" name="password" type="password" required />
        <TextInput label="Zip Code" name="zip" type="text" required />
        <Button type="submit">Sign in</Button>
      </form>
    </MainWrapper>
  );
};

export default LoginPage;
