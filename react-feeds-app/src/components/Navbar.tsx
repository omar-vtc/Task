import { NavLink } from "react-router-dom";
import { Heart, Home, User } from "lucide-react";

export default function Navbar() {
  return (
    <nav className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 shadow z-50">
      <ul className="flex justify-around items-center h-14 text-sm">
        <NavLink
          to="/feeds"
          className={({ isActive }) =>
            `flex flex-col items-center justify-center ${
              isActive ? "text-blue-600" : "text-gray-500"
            }`
          }
        >
          <Home size={20} />
          <span>Feeds</span>
        </NavLink>

        <NavLink
          to="/likes"
          className={({ isActive }) =>
            `flex flex-col items-center justify-center ${
              isActive ? "text-blue-600" : "text-gray-500"
            }`
          }
        >
          <Heart size={20} />
          <span>Likes</span>
        </NavLink>

        <NavLink
          to="/profile"
          className={({ isActive }) =>
            `flex flex-col items-center justify-center ${
              isActive ? "text-blue-600" : "text-gray-500"
            }`
          }
        >
          <User size={20} />
          <span>Profile</span>
        </NavLink>
      </ul>
    </nav>
  );
}
