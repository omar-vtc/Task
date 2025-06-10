import type { Feed } from "../entities/Feed";

interface Props {
  feed: Feed;
  onLike?: () => void;
}

export default function FeedCard({ feed, onLike }: Props) {
  const isLiked = feed.likes?.includes(feed.userId._id);

  return (
    <div className="relative mb-4 rounded-lg overflow-hidden shadow-sm bg-white">
      <img
        src={feed.url}
        alt="Feed"
        className="w-full h-96 object-cover transition-transform duration-300 hover:scale-105"
      />

      {onLike && (
        <button
          onClick={onLike}
          className="absolute top-3 right-3 bg-white shadow px-3 py-1 rounded-full text-sm font-medium flex items-center gap-1"
        >
          {isLiked ? "💖" : "🤍"} {feed.likes?.length}
        </button>
      )}

      <div className="p-3">
        <p className="text-sm text-gray-700">
          Posted by{" "}
          <span className="font-semibold">{feed.userId.firstName}</span>
        </p>
      </div>
    </div>
  );
}
