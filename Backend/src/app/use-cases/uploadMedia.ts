import { MediaModel } from "../../infrastructure/models/MediaModel";
import { Media } from "../../domain/entities/Media";
import mongoose from "mongoose";

export const saveMedia = async (mediaData: Omit<Media, "uploadedAt">) => {
  const media = new MediaModel(mediaData);
  return media.save();
};

export const getFeed = async (page: number, limit: number) => {
  const skip = (page - 1) * limit;

  const [data, total] = await Promise.all([
    MediaModel.find()
      .sort({ uploadedAt: -1 })
      .skip(skip)
      .limit(limit)
      .populate("userId", "firstName lastName")
      .lean(),

    MediaModel.countDocuments(),
  ]);

  return {
    data,
    total,
    page,
    limit,
  };
};
export const toggleLike = async (mediaId: string, userId: string) => {
  const media = await MediaModel.findById(mediaId);
  if (!media) throw new Error("Media not found");

  const hasLiked = media.likes.some((id) => id.toString() === userId);

  if (hasLiked) {
    media.likes = media.likes.filter((id) => id.toString() !== userId);
  } else {
    media.likes.push(new mongoose.Types.ObjectId(userId));
  }

  await media.save();
  return { liked: !hasLiked };
};

export const getLikedFeeds = async (
  userId: string,
  page: number,
  limit: number
) => {
  const skip = (page - 1) * limit;

  const [data, total] = await Promise.all([
    MediaModel.find({ likes: userId })
      .sort({ uploadedAt: -1 })
      .skip(skip)
      .limit(limit)
      .populate("userId", "firstName lastName")
      .lean(),
    MediaModel.countDocuments({ likes: userId }),
  ]);

  return {
    data,
    total,
    page,
    limit,
  };
};
