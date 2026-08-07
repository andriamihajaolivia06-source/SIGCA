import axios from "axios";

const api = axios.create({
  baseURL: "/api",
  headers: {
    "Content-Type": "application/json",
  },
});

export const getAuthOptions = async () => {
  const response = await api.get("/auth/options");
  return response.data;
};

export const login = async (credentials) => {
  const response = await api.post("/auth/login", credentials);
  
  if (response.data.success && response.data.user) {
   
    localStorage.setItem("user", JSON.stringify(response.data.user));
    localStorage.setItem("token", response.data.user.token);
    
   
    const role = response.data.user.role;
    const redirectMap = {
      "admin": "/admin",
      "secretaire": "/secretary",
      "verificateur": "/verifier",
      "delegue": "/delegate",
      "responsable": "/responsible"
    };
    
    const redirectPath = redirectMap[role] || "/";
    window.location.href = redirectPath;
  }
  
  return response.data;
};

export const logout = () => {
  localStorage.removeItem("user");
  localStorage.removeItem("token");
  window.location.href = "/";
};

export const getCurrentUser = () => {
  const user = localStorage.getItem("user");
  return user ? JSON.parse(user) : null;
};

export const getToken = () => {
  return localStorage.getItem("token");
};