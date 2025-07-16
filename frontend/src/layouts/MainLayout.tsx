import * as React from "react";

function MainLayout(children: React.ReactNode): React.ReactElement {
  // TODO: Add Navbar, footer, etc.
  return <div className="min-h-screen bg-white">{children}</div>;
}

export default MainLayout;
