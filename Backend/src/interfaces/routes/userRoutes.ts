import express from "express";
import { authenticate } from "../middleware/authMiddleware";
import {
  getUserProfile,
  registerUser,
  userLogin,
} from "../controllers/userController";

const router = express.Router();

router.post("/register", registerUser);

router.post("/login", userLogin);

router.get("/profile", authenticate, getUserProfile);

export default router;
