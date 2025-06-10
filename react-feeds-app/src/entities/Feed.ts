export interface Feed {
  _id: string;
  url: string;
  likes: string[];
  userId: {
    _id: string;
    firstName: string;
    lastName: string;
  };
}
