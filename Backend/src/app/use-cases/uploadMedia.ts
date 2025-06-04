import { MediaModel } from "../../infrastructure/models/MediaModel";

export const saveMedia = async (
  userId: string,
  fileName: string,
  mediaType: "image" | "video"
) => {
  const media = new MediaModel({ userId, fileName, mediaType });
  return media.save();
};

export const getFeed = async () => {
  return MediaModel.find()
    .sort({ uploadedAt: -1 })
    .populate("userId", "firstName lastName");
};
