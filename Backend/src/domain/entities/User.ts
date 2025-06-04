import { Types } from "mongoose";

export interface User {
  firstName: string;
  lastName: string;
  phoneNumber: string;
  password: string;
}
export interface UserFromDb extends User {
  _id: Types.ObjectId;
  __v: Number;
}
