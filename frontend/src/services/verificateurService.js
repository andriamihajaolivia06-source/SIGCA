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

export const receptionEngagements = async (data) => {
  const response = await api.post("/verificateur/reception", data);
  return response.data;
};

export const getReceivedEngagements = async (immatricule, annee) => {
  const response = await api.get("/verificateur/received-engagements", {
    params: { immatricule, annee }
  });
  return response.data;
};

export const getEngagementDetails = async (numDef) => {
  const response = await api.get("/verificateur/engagement-details", {
    params: { numDef }
  });
  return response.data;
};

export const getMotifs = async () => {
  const response = await api.get("/verificateur/motifs");
  return response.data;
};

export const saveVerification = async (data) => {
  const response = await api.post("/verificateur/save-verification", data);
  return response.data;
};

export const getDelegateDecisions = async (immatricule, annee) => {
  const response = await api.get("/verificateur/delegate-decisions", {
    params: { immatricule, annee }
  });
  return response.data;
};

export const markDecisionAsRead = async (idDel) => {
  const response = await api.post("/verificateur/mark-decision-read", { id_del: idDel });
  return response.data;
};

export const getEngagementFullDetails = async (numDef) => {
  const response = await api.get("/verificateur/engagement-full-details", {
    params: { numDef }
  });
  return response.data;
};

export const getDecisionMotifDetails = async (numDef) => {
  const response = await api.get("/verificateur/decision-motif-details", {
    params: { numDef }
  });
  return response.data;
};

export const getDelegateClosedEngagements = async (immatricule, annee, search) => {
  const response = await api.get("/verificateur/delegate-closed-engagements", {
    params: { immatricule, annee, search: search || '%' }
  });
  return response.data;
};

export const receptionDelegueEngagements = async (data) => {
  const response = await api.post("/verificateur/reception-delegue", data);
  return response.data;
};