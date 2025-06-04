import express from "express";
import { register, login, getProfile } from "../../app/services/authService";
import { authenticate } from "../middleware/authMiddleware";

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

router.get("/profile", authenticate, async (req: any, res) => {
  //   console.log(req);
  try {
    const user = await getProfile(req.user.id);
    res.json(user);
  } catch (e: any) {
    res.status(404).json({ error: e.message });
  }
});

export default router;
