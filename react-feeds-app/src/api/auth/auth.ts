import type { User } from "../../entities/User";
import api from "../client";

export async function login(phoneNumber: string, password: string) {
  const res = await api.post("/users/login", { phoneNumber, password });
  return res.data; // { user, token }
}
export const register = async (userData: User): Promise<User> => {
  const response = await api.post<User>("users/register", userData);
  return response.data;
};
