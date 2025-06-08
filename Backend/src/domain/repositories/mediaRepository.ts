import { Media } from "../entities/Media";

export interface MediaRepository {
  save(media: Media): Promise<Media>;
  findById(id: string): Promise<Media | null>;
  findAllByUserId(userId: string): Promise<Media[]>;
  deleteById(id: string): Promise<void>;
}
