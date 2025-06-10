import express from "express";
import userRoutes from "./interfaces/routes/userRoutes";
import mediaRoutes from "./interfaces/routes/mediaRoutes";
import mongoose from "mongoose";
import dotenv from "dotenv";
import cors from "cors";
import path from "path";
import { connectDB } from "./configs/db";
import "./configs/redis"; // import triggers connection + logs

dotenv.config();

connectDB()
  .then(() => console.log("✅ Database connection established"))
  .catch((err: any) => {
    console.error("❌ Database connection failed:", err);
    process.exit(1);
  });

const app = express();
app.use(
  cors({
    origin: "http://localhost:5173", // allow your frontend
    credentials: true, // if you're using cookies or auth headers
  })
);
app.use(express.json());
app.use("/uploads", express.static(path.join(__dirname, "../uploads")));

app.use("/api/users", userRoutes);
app.use("/api/media", mediaRoutes);

// 📌 Start Server
const PORT = process.env.PORT || 8080;
app.listen(PORT, () =>
  console.log(`🚀 Server running on http://localhost:${PORT}`)
);
