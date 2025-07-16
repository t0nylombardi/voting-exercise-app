import React from "react";
import clsx from "clsx";

interface TextInputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label: string;
  name: string;
}

const TextInput = ({ label, name, className, ...props }: TextInputProps) => {
  return (
    <div className="mb-4">
      <label
        htmlFor={name}
        className="block text-sm font-medium text-gray-700 mb-2"
      >
        {label}
      </label>
      <input
        id={name}
        name={name}
        className={clsx(
          "w-full px-3 py-3 border border-black bg-white rounded-lg",
          "focus:outline-none focus:ring-2 focus:ring-white transition",
          className
        )}
        {...props}
      />
    </div>
  );
};

export default TextInput;
