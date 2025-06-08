import mongoose from "mongoose";

const UserSchema = new mongoose.Schema({
  firstName: String,
  lastName: String,
  phoneNumber: { type: String, unique: true },
  password: String,
});

export const UserModel = mongoose.model("User", UserSchema);
