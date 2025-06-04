import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { UserModel } from "../../infrastructure/models/UserModel";

export const register = async (userData: any) => {
  const hashedPassword = await bcrypt.hash(userData.password, 10);
  const user = new UserModel({ ...userData, password: hashedPassword });
  return user.save();
};

export const login = async (phoneNumber: string, password: string) => {
  const user = await UserModel.findOne({ phoneNumber });
  if (!user) throw new Error("User not found");
  const match = await bcrypt.compare(password, user.password!);
  if (!match) throw new Error("Invalid password");

  const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET!, {
    expiresIn: "1d",
  });
  return { user, token };
};
