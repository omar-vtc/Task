import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { register } from "../api/auth/auth";
import type { User } from "../entities/User";
import { AxiosError } from "axios";

export default function SignUp() {
  const [form, setForm] = useState<User>({
    firstName: "",
    lastName: "",
    phoneNumber: "",
    password: "",
  });

  const navigate = useNavigate();

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>): void => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleRegister = async (): Promise<void> => {
    try {
      await register(form);
      navigate("/login");
    } catch (e: unknown) {
      let errorMessage = "Unknown error";

      if (e instanceof AxiosError) {
        errorMessage = e.response?.data?.error || e.message;
      } else if (e instanceof Error) {
        errorMessage = e.message;
      }

      alert("Registration failed: " + errorMessage);
    }
  };

  return (
    <div className="h-screen w-full flex items-center justify-center bg-gradient-to-br from-blue-50 via-white to-blue-100">
      <div className="w-full max-w-md bg-white rounded-2xl shadow-xl p-8">
        <h2 className="text-2xl font-semibold text-center text-blue-700 mb-6">
          Create Account
        </h2>
        <div className="flex flex-col gap-4">
          <input
            name="firstName"
            placeholder="First Name"
            value={form.firstName}
            onChange={handleChange}
            className="p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <input
            name="lastName"
            placeholder="Last Name"
            value={form.lastName}
            onChange={handleChange}
            className="p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <input
            name="phoneNumber"
            placeholder="Phone Number"
            value={form.phoneNumber}
            onChange={handleChange}
            className="p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <input
            name="password"
            placeholder="Password"
            type="password"
            value={form.password}
            onChange={handleChange}
            className="p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <button
            onClick={handleRegister}
            className="bg-blue-600 hover:bg-blue-700 text-white font-medium py-3 rounded-lg transition duration-200"
          >
            Sign Up
          </button>
        </div>
        <p className="text-center text-sm text-gray-500 mt-6">
          Already have an account?{" "}
          <span
            className="text-blue-600 cursor-pointer"
            onClick={() => navigate("/login")}
          >
            Login
          </span>
        </p>
      </div>
    </div>
  );
}
