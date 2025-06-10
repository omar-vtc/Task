import React, { useState, useEffect, useRef } from "react";
import InfiniteScroll from "react-infinite-scroll-component";
import { getFeeds, toggleLike, uploadMedia } from "../api/feeds/feeds";
import FeedCard from "../components/FeedCard";
import { useAuthStore } from "../store/authStore";
import { useNavigate } from "react-router-dom";
import type { Feed } from "../entities/Feed";

export default function Feeds() {
  const [feeds, setFeeds] = useState<Feed[]>([]);
  const [page, setPage] = useState(1);
  const [hasMore, setHasMore] = useState(true);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const user = useAuthStore((s) => s.user)!;
  const auth = useAuthStore();
  const navigate = useNavigate();
  console.log("userrr", user);
  useEffect(() => {
    fetchMore();
  }, []);

  async function fetchMore() {
    const newFeeds = await getFeeds(page);
    setFeeds((prev) => [...prev, ...newFeeds]);
    if (newFeeds.length === 0) setHasMore(false);
    setPage((p) => p + 1);
  }

  function onToggle(feedId: string) {
    toggleLike(feedId).then(() => {
      setFeeds((prev) =>
        prev.map((f) =>
          f._id === feedId
            ? {
                ...f,
                likes: f.likes.includes(user._id)
                  ? f.likes.filter((id: string) => id !== user._id)
                  : [...f.likes, user._id],
              }
            : f
        )
      );
    });
  }

  const handleUploadClick = () => {
    fileInputRef.current?.click();
  };

  const handleFileChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    try {
      const uploadedMedia = await uploadMedia(file);

      const newFeed: Feed = {
        _id: uploadedMedia._id,
        url: uploadedMedia.url,
        likes: uploadedMedia.likes || [],
        userId: uploadedMedia.userId,
      };

      setFeeds((prev) => [newFeed, ...prev]);
    } catch (error) {
      console.error(error);
      alert("Failed to upload file.");
    } finally {
      if (fileInputRef.current) {
        fileInputRef.current.value = "";
      }
    }
  };

  return (
    <div className="min-h-screen bg-gray-100 flex justify-center items-start py-6 relative">
      <div className="w-full max-w-sm bg-white rounded-xl shadow-lg border border-gray-200 overflow-hidden">
        <header className="flex justify-between items-center p-4 border-b border-gray-200">
          <h1 className="text-xl font-bold">Feeds</h1>
          <button
            onClick={() => auth.logout().then(() => navigate("/login"))}
            className="text-red-600 hover:underline text-sm"
          >
            Logout
          </button>
        </header>

        <InfiniteScroll
          key={feeds.length}
          dataLength={feeds.length}
          next={fetchMore}
          hasMore={hasMore}
          loader={<h4 className="text-center py-4">Loading...</h4>}
          endMessage={
            <p className="text-center py-4 text-gray-500">No more feeds.</p>
          }
        >
          {feeds.map((f) => (
            <FeedCard key={f._id} feed={f} onLike={() => onToggle(f._id)} />
          ))}
        </InfiniteScroll>
      </div>

      <button
        onClick={handleUploadClick}
        className="fixed bottom-16 right-6 bg-blue-600 hover:bg-blue-700 text-white w-14 h-14 rounded-full shadow-lg text-3xl flex items-center justify-center"
        aria-label="Upload"
      >
        ⬆️
      </button>

      <input
        type="file"
        accept="image/*,video/*"
        ref={fileInputRef}
        onChange={handleFileChange}
        style={{ display: "none" }}
      />
    </div>
  );
}
