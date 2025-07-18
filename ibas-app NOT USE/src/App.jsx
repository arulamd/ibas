import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import LoginPage from "./pages/LoginPage";
import MainPage from "./pages/MainPage";
import DashboardPage from "./pages/DashboardPage";
import ProtectedRoute from "./components/ProtectedRoute";
import AppLayout from "./layout/AppLayout";

function App() {
  const isLoggedIn = !!localStorage.getItem("auth");

  return (
    <BrowserRouter>
      <Routes>
        {/* Base redirect */}
        <Route path="/" element={<Navigate to={isLoggedIn ? "/main" : "/login"} />} />

        {/* Public route */}
        <Route path="/login" element={<LoginPage />} />

        {/* ✅ Protected layout route */}
        <Route
          path="/main"
          element={
            <ProtectedRoute isLoggedIn={isLoggedIn}>
              <AppLayout />
            </ProtectedRoute>
          }
        >
          {/* ✅ Nested routes go here */}
          <Route index element={<MainPage />} />
          <Route path="dashboard" element={<DashboardPage />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;
