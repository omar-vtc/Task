import { Types } from "mongoose";

export interface Media {
  userId: Types.ObjectId;
  url: string;
  fileName: string;
  publicId: string;
  mediaType: "image" | "video";
  uploadedAt: Date;
}
