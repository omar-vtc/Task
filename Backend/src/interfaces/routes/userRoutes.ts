import express from "express";
import { register, login } from "../../app/services/authService";

const router = express.Router();

router.post("/register", async (req, res) => {
  try {
    const user = await register(req.body);
    res.json(user);
  } catch (e: any) {
    res.status(400).json({ error: e.message });
  }
});

router.post("/login", async (req, res) => {
  try {
    const { user, token } = await login(
      req.body.phoneNumber,
      req.body.password
    );
    res.json({ user, token });
  } catch (e: any) {
    res.status(401).json({ error: e.message });
  }
});

export default router;
