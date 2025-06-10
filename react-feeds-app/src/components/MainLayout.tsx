import { Outlet } from "react-router-dom";
import Navbar from "./Navbar";

export default function MainLayout() {
  return (
    <div className="min-h-screen pb-16">
      {" "}
      <Outlet />
      <Navbar />
    </div>
  );
}
