import express from "express";
import multer from "multer";
import jwt from "jsonwebtoken";
import { saveMedia, getFeed } from "../../app/use-cases/uploadMedia";

const router = express.Router();
const upload = multer({ dest: "uploads/" });

const authenticate = (req: any, res: any, next: any) => {
  try {
    const token = req.headers.authorization?.split(" ")[1];
    const payload = jwt.verify(token, process.env.JWT_SECRET!);
    req.user = payload;
    next();
  } catch {
    res.status(403).json({ error: "Unauthorized" });
  }
};

router.post(
  "/upload",
  authenticate,
  upload.single("file"),
  async (req: any, res) => {
    const file = req.file;
    const type = file.mimetype.startsWith("image") ? "image" : "video";
    const media = await saveMedia(req.user.id, file.filename, type);
    res.json(media);
  }
);

router.get("/feed", async (req, res) => {
  const feed = await getFeed();
  res.json(feed);
});

export default router;
