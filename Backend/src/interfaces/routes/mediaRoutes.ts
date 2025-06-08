import express from "express";
import multer from "multer";
import jwt from "jsonwebtoken";
import { saveMedia, getFeed } from "../../app/use-cases/uploadMedia";
import { authenticate } from "../middleware/authMiddleware";
import cloudinary from "../../configs/cloudinary";

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

router.post(
  "/upload",
  authenticate,
  upload.single("file"),
  async (req: any, res) => {
    try {
      const file = req.file;
      const fileBase64 = `data:${file.mimetype};base64,${file.buffer.toString(
        "base64"
      )}`;

      const result = await cloudinary.uploader.upload(fileBase64, {
        resource_type: "auto",
      });

      const mediaType = file.mimetype.startsWith("image") ? "image" : "video";

      const media = await saveMedia(
        req.user.id,
        file.originalname,
        mediaType,
        result.secure_url,
        result.public_id
      );

      res.status(201).json(media);
    } catch (error) {
      console.error("Upload Error:", error);
      res.status(500).json({ error: "Failed to upload media" });
    }
  }
);

router.get("/feed", async (req, res) => {
  const feed = await getFeed();
  res.json(feed);
});

export default router;
