import React from "react";
import clsx from "clsx";

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  children: React.ReactNode;
  className?: string;
}

const Button = ({ children, className, ...props }: ButtonProps) => {
  return (
    <button
      className={clsx(
        "w-1/2 px-2 py-2 text-[30px] text-white bg-black rounded-xl hover:bg-black/80",
        "focus:outline-none focus:ring-2 focus:ring-black/50 transition",
        className
      )}
      {...props}
    >
      {children}
    </button>
  );
};

export default Button;
