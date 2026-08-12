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

export const getDelegateDelegations = async (immatricule, annee) => {
  const response = await api.get("/delegate/delegations", {
    params: { immatricule, annee }
  });
  return response.data;
};

export const searchClosedEngagements = async (idDelegation, search, annee) => {
  const response = await api.get("/delegate/search-closed", {
    params: { 
      id_delegation: idDelegation, 
      search: search, 
      annee 
    }
  });
  return response.data;
};

export const receptionEngagements = async (data) => {
  const response = await api.post("/delegate/reception", data);
  return response.data;
};

export const getReceivedEngagements = async (immatricule, annee) => {
  const response = await api.get("/delegate/received-engagements", {
    params: { immatricule, annee }
  });
  return response.data;
};

export const getNonClosedBySecretary = async (immatricule, annee) => {
  const response = await api.get("/delegate/non-closed-secretary", {
    params: { immatricule, annee }
  });
  return response.data;
};

export const getNonClosedByVerificateur = async (immatricule, annee) => {
  const response = await api.get("/delegate/non-closed-verificateur", {
    params: { immatricule, annee }
  });
  return response.data;
};

export const getVerificationDetails = async (numDef) => {
  const response = await api.get("/delegate/verification-details", {
    params: { numDef }
  });
  return response.data;
};