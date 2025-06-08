import express from "express";
import { register, login, getProfile } from "../../app/services/authService";
import { authenticate } from "../middleware/authMiddleware";
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
