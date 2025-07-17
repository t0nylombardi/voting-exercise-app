import React from "react";

const MainWrapper = ({ children }: { children: React.ReactNode }) => {
  return (
    <div className="flex items-start justify-start min-h-screen m-20">
      <div className="bg-white p-6 w-full">{children}</div>
    </div>
  );
};

export default MainWrapper;
