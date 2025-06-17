import { Routes, Route, Navigate } from "react-router-dom";
import { useAuthStore } from "./store/authStore";
import Login from "./pages/Login";
import SignUp from "./pages/SignUp";
import Feeds from "./pages/Feeds";
import Likes from "./pages/Likes";
import Profile from "./pages/Profile";
// import MainLayout from "./components/MainLayout";

function App() {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const token = useAuthStore((state: { token: any }) => state.token);

  return (
    <Routes>
      <Route path="/login" element={<Login />} />
      <Route path="/signup" element={<SignUp />} />
      {token && <Route path="/*" element={<MainRoutes />} />}
      {!token && <Route path="/*" element={<Navigate to="/login" replace />} />}
    </Routes>
  );
}

function MainRoutes() {
  return (
    <Routes>
      <Route path="/" element={<Feeds />}>
        <Route path="feeds" element={<Feeds />} />
        <Route path="likes" element={<Likes />} />
        <Route path="profile" element={<Profile />} />
        <Route path="*" element={<Navigate to="/feeds" replace />} />
      </Route>
    </Routes>
  );
}

export default App;
