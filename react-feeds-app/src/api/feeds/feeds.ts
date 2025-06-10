import api from "../client";

export function getFeeds(page: number, limit = 5) {
  return api
    .get("/media/feed", { params: { page, limit } })
    .then((res) => res.data.data);
}

export function toggleLike(feedId: string) {
  return api.post(`/media/feed/${feedId}/like`);
}

export function getLikedFeeds() {
  return api.get("/media/feed/liked").then((res) => res.data.data);
}

export function getProfile() {
  return api.get("/users/profile");
}

export const uploadMedia = async (file: File) => {
  const formData = new FormData();
  formData.append("file", file);

  const response = await api.post("/media/upload", formData, {
    headers: {
      "Content-Type": "multipart/form-data",
    },
  });

  return response.data;
};
