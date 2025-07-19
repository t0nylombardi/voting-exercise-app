import React from "react";
import clsx from "clsx";

interface TextInputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  name: string;
  error?: string;
  className?: string;
}

const TextInput = ({
  label,
  name,
  error,
  className,
  ...props
}: TextInputProps) => {
  return (
    <div>
      {label && (
        <label
          htmlFor={name}
          className="block text-sm font-medium text-gray-700 mb-1"
        >
          {label}
        </label>
      )}
      <input
        id={name}
        name={name}
        className={clsx(
          "w-full px-3 py-3 border rounded-lg",
          error ? "border-red-500" : "border-black",
          "focus:outline-none focus:ring-2 focus:ring-white transition",
          className
        )}
        aria-invalid={!!error}
        aria-describedby={error ? `${name}-error` : undefined}
        {...props}
      />
      {error && (
        <p id={`${name}-error`} className="text-red-500 text-sm mt-1">
          {error}
        </p>
      )}
    </div>
  );
};

export default TextInput;
