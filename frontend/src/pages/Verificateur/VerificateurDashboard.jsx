import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { getVerificateurDelegations, searchClosedEngagements, receptionEngagements, getDelegateDecisions, markDecisionAsRead } from "../../services/verificateurService";
import logoDGCF from "../../assets/logo-dgcf.png";
import DelegationSelector from "../Secretary/components/DelegationSelector";
import VerificateurSidebar from "./components/VerificateurSidebar";
import EngagementsRecus from "./components/EngagementsRecus";
import NotificationModal from "./components/NotificationModal";
import DecisionPdf from "./components/DecisionPdf";

function VerificateurDashboard() {
  const navigate = useNavigate();
  const [delegations, setDelegations] = useState([]);
  const [selectedDelegation, setSelectedDelegation] = useState(null);
  const [loading, setLoading] = useState(false);
  const [user, setUser] = useState(null);
  
  const [activeTab, setActiveTab] = useState("recherche");
  
  const [results, setResults] = useState([]);
  const [searchTerm, setSearchTerm] = useState("");
  const [searching, setSearching] = useState(false);
  const [hasSearched, setHasSearched] = useState(false);
  
  const [selectedItems, setSelectedItems] = useState([]);
  const [receptionLoading, setReceptionLoading] = useState(false);

  const [notifications, setNotifications] = useState([]);
  const [unreadCount, setUnreadCount] = useState(0);
  const [showNotificationModal, setShowNotificationModal] = useState(false);
  const [selectedDecision, setSelectedDecision] = useState(null);
  const [showDecisionModal, setShowDecisionModal] = useState(false);
  const [showPdfModal, setShowPdfModal] = useState(false);

  useEffect(() => {
    const userData = localStorage.getItem("user");
    if (!userData) {
      navigate("/");
      return;
    }
    
    const parsedUser = JSON.parse(userData);
    setUser(parsedUser);
    loadDelegations(parsedUser);
    loadNotifications(parsedUser);
    
    const interval = setInterval(() => {
      loadNotifications(parsedUser);
    }, 30000);
    
    return () => clearInterval(interval);
  }, [navigate]);

  const loadDelegations = async (userData) => {
    setLoading(true);
    try {
      const data = await getVerificateurDelegations(
        userData.immatricule, 
        userData.annee
      );
      setDelegations(data.delegations || []);
      
      if (data.delegations && data.delegations.length > 0) {
        setSelectedDelegation(data.delegations[0]);
      }
    } catch (error) {
      console.error("Erreur chargement délégations:", error);
    } finally {
      setLoading(false);
    }
  };

  const loadNotifications = async (userData) => {
    try {
      const data = await getDelegateDecisions(
        userData.immatricule,
        userData.annee
      );
      setNotifications(data.notifications || []);
      setUnreadCount(data.unread_count || 0);
    } catch (error) {
      console.error("Erreur chargement notifications:", error);
    }
  };

  const handleNotificationClick = async (notification) => {
    try {
      await markDecisionAsRead(notification.id_del);
      setSelectedDecision(notification);
      setShowDecisionModal(true);
      setUnreadCount(prev => Math.max(0, prev - 1));
      loadNotifications(user);
    } catch (error) {
      console.error("Erreur lors du marquage:", error);
    }
  };

  const handleCloseDecisionModal = () => {
    setShowDecisionModal(false);
    setSelectedDecision(null);
    loadNotifications(user);
  };

  const handleCloseNotificationModal = () => {
    setShowNotificationModal(false);
    loadNotifications(user);
  };

  const handlePrint = () => {
    setShowPdfModal(true);
  };

  const handleClosePdfModal = () => {
    setShowPdfModal(false);
  };

  const handleDelegationChange = (delegation) => {
    setSelectedDelegation(delegation);
    setResults([]);
    setSearchTerm("");
    setHasSearched(false);
    setSelectedItems([]);
  };

  const handleSearch = async () => {
    if (!selectedDelegation) {
      alert("Veuillez sélectionner une délégation");
      return;
    }

    setSearching(true);
    setHasSearched(true);
    setSelectedItems([]);
    try {
      const data = await searchClosedEngagements(
        selectedDelegation.id_delegation,
        searchTerm || '%',
        user?.annee
      );
      setResults(data.results || []);
    } catch (error) {
      console.error("Erreur recherche:", error);
      setResults([]);
    } finally {
      setSearching(false);
    }
  };

  const handleKeyPress = (e) => {
    if (e.key === "Enter") {
      handleSearch();
    }
  };

  const handleToggleSelect = (id) => {
    setSelectedItems(prev => {
      if (prev.includes(id)) {
        return prev.filter(item => item !== id);
      } else {
        return [...prev, id];
      }
    });
  };

  const handleSelectAll = () => {
    if (selectedItems.length === results.length && results.length > 0) {
      setSelectedItems([]);
    } else {
      setSelectedItems(results.map(item => item.id_secretaire));
    }
  };

  const handleReception = async () => {
    if (selectedItems.length === 0) {
      alert("Veuillez sélectionner au moins un engagement");
      return;
    }

    const selectedData = results.filter(item => 
      selectedItems.includes(item.id_secretaire)
    );

    const dataToSend = {
      immatricule: user?.immatricule,
      annee: user?.annee,
      cf_code: selectedDelegation?.cf_code || '',
      selectedEngagements: selectedData.map(item => ({
        id_secretaire: item.id_secretaire,
        numDef: item.numDef
      }))
    };

    if (!window.confirm(`Confirmer la réception de ${selectedItems.length} engagement(s) ?`)) {
      return;
    }

    setReceptionLoading(true);
    try {
      const response = await receptionEngagements(dataToSend);
      
      if (response.success) {
        alert(`${response.message}\n${response.total} engagement(s) réceptionné(s)`);
        setSelectedItems([]);
        handleSearch();
      } else {
        alert(`Erreur: ${response.message || 'Une erreur est survenue'}`);
      }
    } catch (error) {
      console.error("Erreur lors de la réception:", error);
      alert("Erreur lors de la réception. Veuillez réessayer.");
    } finally {
      setReceptionLoading(false);
    }
  };

  const formatDate = (dateString) => {
    if (!dateString) return "-";
    try {
      return new Date(dateString).toLocaleDateString("fr-FR") + " " + 
             new Date(dateString).toLocaleTimeString("fr-FR");
    } catch {
      return "-";
    }
  };

  const formatMontant = (montant) => {
    if (!montant) return "0 Ar";
    return Number(montant).toLocaleString("fr-FR") + " Ar";
  };

  const getStatusBadge = (status) => {
    const colors = {
      "Cloturer": "bg-green-100 text-green-700",
      "En attente": "bg-yellow-100 text-yellow-700",
      "Rejete": "bg-red-100 text-red-700",
      "Verifie": "bg-blue-100 text-blue-700",
      "Noncloturer": "bg-yellow-100 text-yellow-700",
    };
    const color = colors[status] || "bg-gray-100 text-gray-700";
    return (
      <span className={`px-2 py-1 rounded-full text-xs font-medium ${color}`}>
        {status || "En attente"}
      </span>
    );
  };

  const renderContent = () => {
    switch (activeTab) {
      case "recherche":
        return (
          <>
            <div className="mb-6">
              <DelegationSelector
                delegations={delegations}
                selectedDelegation={selectedDelegation}
                onDelegationChange={handleDelegationChange}
              />
            </div>

            <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 mb-6">
              <div className="flex flex-col sm:flex-row gap-4">
                <div className="flex-1">
                  <label className="block text-sm font-medium text-[#0B1F44] mb-1">
                    Rechercher les engagements clôturés
                  </label>
                  <div className="flex gap-2">
                    <input
                      type="text"
                      placeholder="Entrez % pour tout afficher ou un terme de recherche..."
                      value={searchTerm}
                      onChange={(e) => setSearchTerm(e.target.value)}
                      onKeyPress={handleKeyPress}
                      className="flex-1 px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:border-[#6FAE4F] focus:ring-4 focus:ring-[#6FAE4F]/20 transition-all"
                    />
                    <button
                      onClick={handleSearch}
                      disabled={searching}
                      className="px-6 py-2.5 bg-[#0B1F44] text-white rounded-lg hover:bg-[#122a5c] disabled:opacity-60 disabled:cursor-not-allowed transition-colors font-medium whitespace-nowrap"
                    >
                      {searching ? "Recherche..." : "Rechercher"}
                    </button>
                  </div>
                  <p className="text-xs text-gray-400 mt-1">
                    Utilisez % pour afficher tous les engagements clôturés
                  </p>
                </div>
              </div>
            </div>

            {hasSearched && (
              <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                <div className="px-6 py-4 bg-gray-50/80 border-b border-gray-200 flex items-center justify-between">
                  <h3 className="text-lg font-semibold text-[#0B1F44]">
                    Résultats ({results.length})
                  </h3>
                  {selectedDelegation && (
                    <span className="text-sm text-gray-500">
                      Délégation: {selectedDelegation.cf_code}
                    </span>
                  )}
                </div>

                {searching ? (
                  <div className="flex items-center justify-center py-12">
                    <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#0B1F44]"></div>
                    <span className="ml-3 text-gray-500">Recherche en cours...</span>
                  </div>
                ) : results.length === 0 ? (
                  <div className="text-center py-12">
                    <p className="text-gray-500">Aucun engagement trouvé pour cette recherche.</p>
                  </div>
                ) : (
                  <>
                    <div className="overflow-x-auto">
                      <table className="w-full text-sm">
                        <thead className="bg-gray-50 border-b border-gray-200">
                          <tr>
                            <th className="px-4 py-3 text-left w-10">
                              <input
                                type="checkbox"
                                checked={selectedItems.length === results.length && results.length > 0}
                                onChange={handleSelectAll}
                                className="w-4 h-4 rounded border-gray-300 text-[#0B1F44] focus:ring-[#6FAE4F]"
                              />
                            </th>
                            <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">N° DEF</th>
                            <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">BDEF</th>
                            <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">Réf CF</th>
                            <th className="px-4 py-3 text-right font-semibold text-[#0B1F44]">Montant</th>
                            <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">Date clôture</th>
                            <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">Clôturé par</th>
                            <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">Statut</th>
                          </tr>
                        </thead>
                        <tbody className="divide-y divide-gray-100">
                          {results.map((item) => (
                            <tr key={item.id_secretaire} className="hover:bg-gray-50 transition-colors">
                              <td className="px-4 py-3">
                                <input
                                  type="checkbox"
                                  checked={selectedItems.includes(item.id_secretaire)}
                                  onChange={() => handleToggleSelect(item.id_secretaire)}
                                  className="w-4 h-4 rounded border-gray-300 text-[#0B1F44] focus:ring-[#6FAE4F]"
                                />
                              </td>
                              <td className="px-4 py-3 font-mono text-sm text-gray-700">
                                {item.numDef || "-"}
                              </td>
                              <td className="px-4 py-3 font-mono text-sm text-[#0B1F44]">
                                {item.bdef || "-"}
                              </td>
                              <td className="px-4 py-3 text-sm text-gray-600">
                                {item.refCF || "-"}
                              </td>
                              <td className="px-4 py-3 text-right font-medium text-[#0B1F44]">
                                {formatMontant(item.montant)}
                              </td>
                              <td className="px-4 py-3 text-sm text-gray-600">
                                {formatDate(item.dateCloture)}
                              </td>
                              <td className="px-4 py-3 text-sm text-gray-600">
                                {item.loginCloture || "-"}
                              </td>
                              <td className="px-4 py-3">
                                {getStatusBadge(item.etatSecVerif)}
                              </td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                    <div className="px-6 py-4 bg-gray-50/80 border-t border-gray-200 flex justify-end">
                      <button
                        onClick={handleReception}
                        disabled={selectedItems.length === 0 || receptionLoading}
                        className="px-6 py-2 bg-[#0B1F44] text-white rounded-lg hover:bg-[#122a5c] disabled:opacity-50 disabled:cursor-not-allowed transition-colors font-medium"
                      >
                        {receptionLoading ? "Réception en cours..." : "Réceptionner"}
                      </button>
                    </div>
                  </>
                )}
              </div>
            )}
          </>
        );

      case "recus":
        return <EngagementsRecus user={user} />;

      default:
        return null;
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-[#0B1F44] mx-auto"></div>
          <p className="mt-4 text-gray-600">Chargement...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 flex">
      <VerificateurSidebar activeTab={activeTab} onTabChange={setActiveTab} />

      <div className="flex-1 min-h-screen">
        <header className="bg-[#0B1F44] text-white shadow-lg sticky top-0 z-20">
          <div className="px-4 py-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <img src={logoDGCF} alt="Logo" className="h-10 w-10 object-contain" />
                <div>
                  <h1 className="text-xl font-bold">SIGCA</h1>
                  <p className="text-xs text-gray-300">SIG Contrôle A Priori</p>
                </div>
              </div>
              <div className="flex items-center gap-4">
                <button
                  onClick={() => setShowNotificationModal(true)}
                  className="relative text-white hover:text-gray-300 transition-colors"
                >
                  <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
                  </svg>
                  {unreadCount > 0 && (
                    <span className="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">
                      {unreadCount > 9 ? '9+' : unreadCount}
                    </span>
                  )}
                </button>
                <div className="text-right">
                  <p className="text-sm font-medium">
                    {user?.nom} {user?.prenom}
                  </p>
                  <p className="text-xs text-gray-300">
                    {user?.role} • Année {user?.annee}
                  </p>
                </div>
              </div>
            </div>
          </div>
        </header>

        <main className="p-6">
          {renderContent()}
        </main>
      </div>

      {/* Modal de notification */}
      {showNotificationModal && (
        <NotificationModal
          notifications={notifications}
          user={user}
          onClose={handleCloseNotificationModal}
          onNotificationClick={handleNotificationClick}
          onRefresh={() => loadNotifications(user)}
        />
      )}

      {/* Modal de décision */}
      {showDecisionModal && selectedDecision && (
        <div className="fixed inset-0 bg-black/50 z-60 flex items-center justify-center p-4">
          <div className="bg-white rounded-xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto p-6">
            <div className="flex items-center justify-between mb-4 pb-4 border-b border-gray-200">
              <h3 className="text-lg font-bold text-[#0B1F44]">Décision du Délégué</h3>
              <button
                onClick={handleCloseDecisionModal}
                className="text-gray-400 hover:text-gray-600 transition-colors"
              >
                ✕
              </button>
            </div>
            
            <div className="space-y-3">
              <div className="grid grid-cols-2 gap-2 text-sm">
                <span className="font-semibold text-gray-600">N° DEF :</span>
                <span className="text-gray-800">{selectedDecision.numDef || "-"}</span>
              </div>
              <div className="grid grid-cols-2 gap-2 text-sm">
                <span className="font-semibold text-gray-600">BDEF :</span>
                <span className="text-gray-800">{selectedDecision.bdef || "-"}</span>
              </div>
              <div className="grid grid-cols-2 gap-2 text-sm">
                <span className="font-semibold text-gray-600">Réf CF :</span>
                <span className="text-gray-800">{selectedDecision.refCF || "-"}</span>
              </div>
              <div className="grid grid-cols-2 gap-2 text-sm">
                <span className="font-semibold text-gray-600">Montant :</span>
                <span className="text-gray-800 font-medium">
                  {selectedDecision.montant ? Number(selectedDecision.montant).toLocaleString("fr-FR") + " Ar" : "0 Ar"}
                </span>
              </div>
              <div className="grid grid-cols-2 gap-2 text-sm">
                <span className="font-semibold text-gray-600">Objet :</span>
                <span className="text-gray-800">{selectedDecision.objet || "-"}</span>
              </div>
              <div className="grid grid-cols-2 gap-2 text-sm">
                <span className="font-semibold text-gray-600">Décision Forme :</span>
                <span className="text-gray-800">{selectedDecision.decisionforme || "-"}</span>
              </div>
              <div className="grid grid-cols-2 gap-2 text-sm">
                <span className="font-semibold text-gray-600">Décision Fond :</span>
                <span className="text-gray-800">{selectedDecision.decisionfond || "-"}</span>
              </div>
              <div className="grid grid-cols-2 gap-2 text-sm">
                <span className="font-semibold text-gray-600">Décision Finale :</span>
                <span className="text-gray-800 font-medium text-[#0B1F44]">{selectedDecision.decisionfinale || "-"}</span>
              </div>
              <div className="grid grid-cols-2 gap-2 text-sm">
                <span className="font-semibold text-gray-600">Observation :</span>
                <span className="text-gray-800">{selectedDecision.decisionObs || "-"}</span>
              </div>
              <div className="grid grid-cols-2 gap-2 text-sm">
                <span className="font-semibold text-gray-600">Date réception :</span>
                <span className="text-gray-800">{formatDate(selectedDecision.dateReception)}</span>
              </div>
              <div className="grid grid-cols-2 gap-2 text-sm">
                <span className="font-semibold text-gray-600">Date clôture :</span>
                <span className="text-gray-800">{formatDate(selectedDecision.dateClotureDel)}</span>
              </div>
              <div className="grid grid-cols-2 gap-2 text-sm">
                <span className="font-semibold text-gray-600">Clôturé par :</span>
                <span className="text-gray-800">{selectedDecision.loginReception || "-"}</span>
              </div>
            </div>

            <div className="flex justify-end gap-3 mt-6 pt-4 border-t border-gray-200">
              <button
                onClick={() => {
                  alert("Fonction de clôture à implémenter");
                }}
                className="px-6 py-2 bg-[#6FAE4F] text-white rounded-lg hover:bg-[#5d9e3f] transition-colors"
              >
                Clôturer
              </button>
              <button
                onClick={handlePrint}
                className="px-6 py-2 bg-[#0B1F44] text-white rounded-lg hover:bg-[#122a5c] transition-colors"
              >
                Imprimer
              </button>
              <button
                onClick={handleCloseDecisionModal}
                className="px-6 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
              >
                Fermer
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Modal PDF */}
      {showPdfModal && selectedDecision && (
        <DecisionPdf
          decision={selectedDecision}
          onClose={handleClosePdfModal}
        />
      )}
    </div>
  );
}

export default VerificateurDashboard;