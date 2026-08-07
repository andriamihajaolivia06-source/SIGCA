import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import Login from "./pages/Login";
import SecretaryDashboard from "./pages/Secretary/SecretaryDashboard";


function PrivateRoute({ children, requiredRole }) {
  const user = JSON.parse(localStorage.getItem("user") || "null");
  
  if (!user) {
    return <Navigate to="/" replace />;
  }
  
  if (requiredRole && user.role !== requiredRole) {
    return <Navigate to="/unauthorized" replace />;
  }
  
  return children;
}

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route 
          path="/secretary" 
          element={
            <PrivateRoute requiredRole="secretaire">
              <SecretaryDashboard />
            </PrivateRoute>
          } 
        />
        {/* Route par défaut pour les chemins non trouvés */}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;