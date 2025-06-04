import mongoose from "mongoose";

const MediaSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  fileName: String,
  mediaType: { type: String, enum: ["image", "video"] },
  uploadedAt: { type: Date, default: Date.now },
});

export const MediaModel = mongoose.model("Media", MediaSchema);

//5otAykQpKGoIyhuC
