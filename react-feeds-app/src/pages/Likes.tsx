import { useState, useEffect } from "react";
import { getLikedFeeds, toggleLike } from "../api/feeds/feeds";
import FeedCard from "../components/FeedCard";
import type { Feed } from "../entities/Feed";

export default function Likes() {
  const [feeds, setFeeds] = useState<Feed[]>([]);

  useEffect(() => {
    getLikedFeeds().then((res) => setFeeds(res));
  }, []);

  function onToggle(feedId: string) {
    toggleLike(feedId).then(() => {
      setFeeds(feeds.filter((f) => f._id !== feedId));
    });
  }

  return (
    <div className="p-4">
      <h1 className="text-xl font-bold mb-4">Liked Posts</h1>
      {feeds.length === 0 ? (
        <p>No liked posts yet.</p>
      ) : (
        <div className="grid grid-cols-3 gap-4">
          {feeds.map((f) => (
            <FeedCard key={f._id} feed={f} onLike={() => onToggle(f._id)} />
          ))}
        </div>
      )}
    </div>
  );
}
