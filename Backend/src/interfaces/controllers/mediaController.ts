import express from "express";
import multer from "multer";
import jwt from "jsonwebtoken";
import {
  saveMedia,
  getFeed,
  getLikedFeeds,
  toggleLike,
} from "../../app/use-cases/uploadMedia";
import cloudinary from "../../configs/cloudinary";

export const uploadMedia = async (req: any, res: any) => {
  try {
    const file = req.file;
    const fileBase64 = `data:${file.mimetype};base64,${file.buffer.toString(
      "base64"
    )}`;

    const result = await cloudinary.uploader.upload(fileBase64, {
      resource_type: "auto",
    });

    const mediaType = file.mimetype.startsWith("image") ? "image" : "video";

    const media = await saveMedia({
      userId: req.user.id,
      fileName: file.originalname,
      mediaType,
      url: result.secure_url,
      publicId: result.public_id,
    });

    res.status(201).json(media);
  } catch (error) {
    console.error("Upload Error:", error);
    res.status(500).json({ error: "Failed to upload media" });
  }
};

export const getFeeds = async (req: any, res: any) => {
  try {
    const page = parseInt(req.query.page as string) || 1;
    const limit = parseInt(req.query.limit as string) || 10;

    const feed = await getFeed(page, limit);
    res.status(200).json(feed);
  } catch (error) {
    console.error("Error fetching feed:", error);
    res.status(500).json({ error: "Failed to fetch feed" });
  }
};
export const likeOrUnlikeFeed = async (req: any, res: any) => {
  try {
    const mediaId = req.params.id;
    const userId = req.user.id;

    const result = await toggleLike(mediaId, userId);
    res.status(200).json({ message: result.liked ? "Liked" : "Unliked" });
  } catch (error) {
    console.error("Like Error:", error);
    res.status(500).json({ error: "Failed to toggle like" });
  }
};

export const getUserLikedFeeds = async (req: any, res: any) => {
  try {
    const userId = req.user.id;
    const page = parseInt(req.query.page as string) || 1;
    const limit = parseInt(req.query.limit as string) || 10;

    const result = await getLikedFeeds(userId, page, limit);
    res.status(200).json(result);
  } catch (error) {
    console.error("Fetch liked feeds error:", error);
    res.status(500).json({ error: "Failed to get liked feeds" });
  }
};
