import express from "express";
import multer from "multer";

import jwt from "jsonwebtoken";
import { saveMedia, getFeed } from "../../app/use-cases/uploadMedia";
import { authenticate } from "../middleware/authMiddleware";
import cloudinary from "../../configs/cloudinary";
import {
  getFeeds,
  getUserLikedFeeds,
  likeOrUnlikeFeed,
  uploadMedia,
} from "../controllers/mediaController";

const router = express.Router();
export const upload = multer({ storage: multer.memoryStorage() });
// const authenticate = (req: any, res: any, next: any) => {
//   try {
//     const token = req.headers.authorization?.split(" ")[1];
//     const payload = jwt.verify(token, process.env.JWT_SECRET!);
//     req.user = payload;
//     next();
//   } catch {
//     res.status(403).json({ error: "Unauthorized" });
//   }
// };

router.post("/upload", authenticate, upload.single("file"), uploadMedia);

router.get("/feed", getFeeds);

router.post("/feed/:id/like", authenticate, likeOrUnlikeFeed);
router.get("/feed/liked", authenticate, getUserLikedFeeds);

export default router;
