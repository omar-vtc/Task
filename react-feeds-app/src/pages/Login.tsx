import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { login } from "../api/auth/auth";
import { useAuthStore } from "../store/authStore";

export default function Login() {
  const [phone, setPhone] = useState("");
  const [pwd, setPwd] = useState("");
  const navigate = useNavigate();
  const auth = useAuthStore();

  const handle = async () => {
    try {
      const { user, token } = await login(phone, pwd);
      auth.login(user, token);
      navigate("/feeds");
    } catch {
      alert("Login failed");
    }
  };

  return (
    <div className="h-screen w-full flex items-center justify-center bg-gradient-to-br from-blue-50 via-white to-blue-100">
      <div className="w-full max-w-md bg-white rounded-2xl shadow-xl p-8">
        <h2 className="text-2xl font-semibold text-center text-blue-700 mb-6">
          Welcome Back
        </h2>
        <div className="flex flex-col gap-4">
          <input
            placeholder="Phone Number"
            value={phone}
            onChange={(e) => setPhone(e.target.value)}
            className="p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <input
            placeholder="Password"
            type="password"
            value={pwd}
            onChange={(e) => setPwd(e.target.value)}
            className="p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <button
            onClick={handle}
            className="bg-blue-600 hover:bg-blue-700 text-white font-medium py-3 rounded-lg transition duration-200"
          >
            Login
          </button>
        </div>
        <p className="text-center text-sm text-gray-500 mt-6">
          Don’t have an account?{" "}
          <span
            className="text-blue-600 cursor-pointer"
            onClick={() => navigate("/signup")}
          >
            Sign up
          </span>
        </p>
      </div>
    </div>
  );
}
