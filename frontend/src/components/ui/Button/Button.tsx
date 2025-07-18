import React from "react";
import clsx from "clsx";

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  children: React.ReactNode;
  loading?: boolean;
}

const Button = ({ children, loading, className, ...props }: ButtonProps) => {
  return (
    <button
      disabled={loading || props.disabled}
      className={clsx(
        "w-1/2 px-2 py-2 text-[30px] text-white bg-black rounded-xl",
        "hover:bg-black/80 focus:outline-none focus:ring-2 focus:ring-black/50 transition",
        loading && "opacity-50 cursor-not-allowed",
        className
      )}
      {...props}
    >
      {loading ? "Signing in..." : children}
    </button>
  );
};

export default Button;
