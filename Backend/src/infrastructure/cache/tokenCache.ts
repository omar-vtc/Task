import redis from "../../configs/redis";

const TOKEN_PREFIX = "auth:token:";

export const setTokenCache = async (
  userId: string,
  token: string,
  ttlSeconds: number = 3600
): Promise<void> => {
  await redis.set(`${TOKEN_PREFIX}${userId}`, token, "EX", ttlSeconds);
};

export const getTokenCache = async (userId: string): Promise<string | null> => {
  return await redis.get(`${TOKEN_PREFIX}${userId}`);
};

export const deleteTokenCache = async (userId: string): Promise<number> => {
  return await redis.del(`${TOKEN_PREFIX}${userId}`);
};
