import React from "react";
import clsx from "clsx";

interface TextInputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  name: string;
  onChange?: (e: React.ChangeEvent<HTMLInputElement>) => void;
  placeholder?: string;
  className?: string;
}

const TextInput = ({
  label,
  name,
  placeholder,
  className,
  onChange,
  ...props
}: TextInputProps) => {
  return (
    <div>
      {label && (
        <label
          htmlFor={name}
          className="block text-sm font-medium text-gray-700 mb-2"
        >
          {label}
        </label>
      )}
      <input
        id={name}
        name={name}
        onChange={onChange}
        className={clsx(
          "w-full px-3 py-3 border border-black bg-white rounded-lg",
          "focus:outline-none focus:ring-2 focus:ring-white transition",
          className
        )}
        placeholder={placeholder}
        {...(props as React.InputHTMLAttributes<HTMLInputElement>)}
      />
    </div>
  );
};

export default TextInput;
