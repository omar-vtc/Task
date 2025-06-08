import { MediaModel } from "../../infrastructure/models/MediaModel";

export const saveMedia = async (
  userId: string,
  fileName: string,
  mediaType: "image" | "video",
  url: string,
  publicId: string
) => {
  const media = new MediaModel({ userId, fileName, mediaType, url, publicId });
  return media.save();
};

export const getFeed = async () => {
  return MediaModel.find()
    .sort({ uploadedAt: -1 })
    .populate("userId", "firstName lastName");
};
