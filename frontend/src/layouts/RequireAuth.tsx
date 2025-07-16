import * as React from "react";

function RequireAuth(children: React.ReactNode): React.ReactElement {
  // TODO: Add real auth logic
  return <>{children}</>;
}

export default RequireAuth;
