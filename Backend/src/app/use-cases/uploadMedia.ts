import { MediaModel } from "../../infrastructure/models/MediaModel";
import { Media } from "../../domain/entities/Media";

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
