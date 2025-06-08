import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";
import redis from "../../configs/redis";

const JWT_SECRET = process.env.JWT_SECRET || "changeme";

export const authenticate = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    res.status(401).json({ error: "Unauthorized: No token provided" });
    return;
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(token, JWT_SECRET) as { id: string };

    const cachedUserId = await redis.get(`auth:token:${token}`);
    if (!cachedUserId || cachedUserId !== decoded.id) {
      res.status(401).json({ error: "Unauthorized: Invalid token" });
      return;
    }

    (req as any).user = { id: decoded.id };
    next(); // ✅ Important!
  } catch (err: any) {
    res.status(401).json({ error: "Unauthorized: " + err.message });
  }
};
