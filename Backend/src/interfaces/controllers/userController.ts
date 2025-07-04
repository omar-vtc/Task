import {
  register,
  login,
  getProfile,
  logout,
} from "../../app/services/authService";
import { User } from "../../domain/entities/User";

export const registerUser = async (req: { body: User }, res: any) => {
  try {
    const user = await register(req.body);
    res.json(user);
  } catch (e: any) {
    res.status(400).json({ error: e.message });
  }
};

export const userLogin = async (req: any, res: any) => {
  //   console.log("called");
  try {
    const { user, token } = await login(
      req.body.phoneNumber,
      req.body.password
    );
    res.json({ user, token });
  } catch (e: any) {
    res.status(401).json({ error: e.message });
  }
};

export const getUserProfile = async (req: any, res: any) => {
  //   console.log(req);
  try {
    const user = await getProfile(req.user.id);
    res.json(user);
  } catch (e: any) {
    res.status(404).json({ error: e.message });
  }
};
export const logoutUser = async (req: any, res: any) => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({ error: "No token provided" });
    }

    const token = authHeader.split(" ")[1];
    const result = await logout(token);

    res.json(result);
  } catch (e: any) {
    res.status(400).json({ error: e.message });
  }
};
