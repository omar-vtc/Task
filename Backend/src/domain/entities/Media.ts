export interface Media {
  userId: string;
  fileName: string;
  mediaType: "image" | "video";
  uploadedAt: Date;
}
