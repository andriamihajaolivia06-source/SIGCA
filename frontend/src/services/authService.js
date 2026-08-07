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

  return response.data;
};