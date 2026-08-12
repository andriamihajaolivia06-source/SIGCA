import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { getDelegateDelegations, searchClosedEngagements, receptionEngagements } from "../../services/delegateService";
import logoDGCF from "../../assets/logo-dgcf.png";
import DelegationSelector from "../Secretary/components/DelegationSelector";
import DelegateSidebar from "./components/DelegateSidebar";
import EngagementsRecusDelegue from "./components/EngagementsRecusDelegue";
import EngagementsNonCloturesSecretaire from "./components/EngagementsNonCloturesSecretaire";
import EngagementsNonCloturesVerificateur from "./components/EngagementsNonCloturesVerificateur";

function DelegateDashboard() {
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

  useEffect(() => {
    const userData = localStorage.getItem("user");
    if (!userData) {
      navigate("/");
      return;
    }
    
    const parsedUser = JSON.parse(userData);
    setUser(parsedUser);
    loadDelegations(parsedUser);
  }, [navigate]);

  const loadDelegations = async (userData) => {
    setLoading(true);
    try {
      const data = await getDelegateDelegations(
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
      setSelectedItems(results.map(item => item.id_verif || item.id_secretaire));
    }
  };

  const handleReception = async () => {
    if (selectedItems.length === 0) {
      alert("Veuillez sélectionner au moins un engagement");
      return;
    }

    const selectedData = results.filter(item => 
      selectedItems.includes(item.id_verif || item.id_secretaire)
    );

    const dataToSend = {
      immatricule: user?.immatricule,
      annee: user?.annee,
      cf_code: selectedDelegation?.cf_code || '',
      selectedEngagements: selectedData.map(item => ({
        id_verif: item.id_verif,
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
        alert(`✅ ${response.message}\n${response.total} engagement(s) réceptionné(s)`);
        setSelectedItems([]);
        handleSearch();
      } else {
        alert(`❌ Erreur: ${response.message || 'Une erreur est survenue'}`);
      }
    } catch (error) {
      console.error("Erreur lors de la réception:", error);
      alert("❌ Erreur lors de la réception. Veuillez réessayer.");
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
      "DEF": "bg-green-100 text-green-700",
    };
    const color = colors[status] || "bg-gray-100 text-gray-700";
    return (
      <span className={`px-2 py-1 rounded-full text-xs font-medium ${color}`}>
        {status || "En attente"}
      </span>
    );
  };

  // Définition des onglets pour le navbar
  const navTabs = [
    { id: "nonclotures_secretaire", label: "Non clôturés (Secrétaire)" },
    { id: "nonclotures_verificateur", label: "Non vérifiés (Vérificateur)" },
  ];

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
                            <tr key={item.id_verif} className="hover:bg-gray-50 transition-colors">
                              <td className="px-4 py-3">
                                <input
                                  type="checkbox"
                                  checked={selectedItems.includes(item.id_verif)}
                                  onChange={() => handleToggleSelect(item.id_verif)}
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
                                {getStatusBadge(item.etatVerifDel)}
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

      case "nonclotures_secretaire":
        return <EngagementsNonCloturesSecretaire user={user} />;

      case "nonclotures_verificateur":
        return <EngagementsNonCloturesVerificateur user={user} />;

      case "recus":
        return <EngagementsRecusDelegue user={user} />;

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
      <DelegateSidebar activeTab={activeTab} onTabChange={setActiveTab} />

      <div className="flex-1 min-h-screen">
        {/* Header avec navbar */}
        <header className="bg-[#0B1F44] text-white shadow-lg sticky top-0 z-20">
          <div className="px-4 py-3">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <img src={logoDGCF} alt="Logo" className="h-10 w-10 object-contain" />
                <div>
                  <h1 className="text-xl font-bold">SIGCA</h1>
                  <p className="text-xs text-gray-300">SIG Contrôle A Priori</p>
                </div>
              </div>
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

          {/* Navbar avec les liens */}
          <div className="bg-[#122a5c] px-4 py-2">
            <div className="flex flex-wrap gap-2">
              {navTabs.map((tab) => (
                <button
                  key={tab.id}
                  onClick={() => setActiveTab(tab.id)}
                  className={`
                    px-4 py-1.5 text-sm rounded-lg transition-colors
                    ${activeTab === tab.id 
                      ? "bg-[#6FAE4F] text-white" 
                      : "text-gray-300 hover:text-white hover:bg-white/10"
                    }
                  `}
                >
                  {tab.label}
                </button>
              ))}
            </div>
          </div>
        </header>

        <main className="p-6">
          {renderContent()}
        </main>
      </div>
    </div>
  );
}

export default DelegateDashboard;