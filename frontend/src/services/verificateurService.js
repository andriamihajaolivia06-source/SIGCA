import axios from "axios";

const api = axios.create({
  baseURL: "/api",
  headers: {
    "Content-Type": "application/json",
  },
});

api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem("token");
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem("user");
      localStorage.removeItem("token");
      window.location.href = "/";
    }
    return Promise.reject(error);
  }
);

export const getVerificateurDelegations = async (immatricule, annee) => {
  const response = await api.get("/verificateur/delegations", {
    params: { immatricule, annee }
  });
  return response.data;
};

export const searchClosedEngagements = async (idDelegation, search, annee) => {
  const response = await api.get("/verificateur/search-closed", {
    params: { 
      id_delegation: idDelegation, 
      search: search, 
      annee 
    }
  });
  return response.data;
};