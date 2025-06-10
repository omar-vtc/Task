import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { UserModel } from "../../infrastructure/models/UserModel";
import redis from "../../configs/redis"; // Add this line
import { User } from "../../domain/entities/User";
import { MediaModel } from "../../infrastructure/models/MediaModel";

const TOKEN_EXPIRY = 60 * 60 * 24; // 1 day in seconds

export const register = async (userData: User) => {
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
  await redis.set(
    `auth:token:${token}`,
    user._id.toString(),
    "EX",
    TOKEN_EXPIRY
  );

  return { user, token };
};
export const getProfile = async (userId: string) => {
  const user = await UserModel.findById(userId).select("-password").lean();

  if (!user) {
    throw new Error("User not found");
  }

  const feeds = await MediaModel.find({ userId })
    .sort({ uploadedAt: -1 })
    .populate("userId", "firstName lastName")
    .lean();

  return {
    user,
    feeds,
  };
};

export const logout = async (token: string) => {
  const redisKey = `auth:token:${token}`;
  const result = await redis.del(redisKey);

  if (result === 0) {
    throw new Error("Invalid or already logged out token");
  }

  return { message: "Logged out successfully" };
};
