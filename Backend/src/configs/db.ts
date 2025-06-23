import mongoose from "mongoose";
import dotenv from "dotenv";

dotenv.config(); // Load environment variables

const uri: string | undefined = process.env.MONGO_URI;
// console.log(process.env.MONGO_URI);

export const connectDB = async (): Promise<void> => {
  if (!uri) {
    console.error("❌ MONGO_URI not defined in environment variables");
    process.exit(1);
  }

  try {
    console.log("hello");
    await mongoose.connect(uri, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      serverSelectionTimeoutMS: 5000, // 5s timeout
    } as mongoose.ConnectOptions); // Cast to ConnectOptions to satisfy TypeScript
    console.log("✅ MongoDB connected successfully");
  } catch (error: any) {
    console.error("❌ MongoDB connection error:", error.message);
    process.exit(1);
  }
};
