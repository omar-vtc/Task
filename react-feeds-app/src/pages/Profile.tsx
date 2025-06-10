import { useEffect, useState } from "react";
import { getProfile } from "../api/feeds/feeds";
import FeedCard from "../components/FeedCard";
import type { User } from "../entities/User";
import type { Feed } from "../entities/Feed";

export default function Profile() {
  const [user, setUser] = useState<User | null>(null);
  const [feeds, setFeeds] = useState<Feed[]>([]);

  useEffect(() => {
    getProfile().then((res) => {
      setUser(res.data.user);
      setFeeds(res.data.feeds);
    });
  }, []);

  if (!user) return <div className="p-4">Loading...</div>;

  return (
    <div className="p-4">
      <h1 className="text-xl font-bold mb-2">
        {user.firstName} {user.lastName}
      </h1>
      <div className="grid grid-cols-3 gap-4">
        {feeds.map((f) => (
          <FeedCard key={f._id} feed={f} />
        ))}
      </div>
    </div>
  );
}
