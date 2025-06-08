import mongoose from "mongoose";

const MediaSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  url: { type: String, required: true },
  fileName: String,
  publicId: { type: String, required: true },
  mediaType: { type: String, enum: ["image", "video"] },
  uploadedAt: { type: Date, default: Date.now },
});

export const MediaModel = mongoose.model("Media", MediaSchema);

//5otAykQpKGoIyhuC
