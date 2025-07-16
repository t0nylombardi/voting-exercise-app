import * as React from "react";

function AuthLayout(children: React.ReactNode): React.ReactElement {
  // TODO: Add auth-specific layout (centered form, etc.)
  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-100">
      {children}
    </div>
  );
}

export default AuthLayout;
