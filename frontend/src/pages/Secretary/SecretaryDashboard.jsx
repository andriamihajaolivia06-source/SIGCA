import { useEffect, useState } from "react";
import { 
  getSecretaryDelegations, 
  searchBDEF, 
  searchDEF 
} from "../../services/secretaryService";
import logoDGCF from "../../assets/logo-dgcf.png";
import SearchSection from "./components/SearchSection";
import DelegationSelector from "./components/DelegationSelector";
import ResultsTable from "./components/ResultsTable";

function SecretaryDashboard() {
  const [delegations, setDelegations] = useState([]);
  const [selectedDelegation, setSelectedDelegation] = useState(null);
  const [loading, setLoading] = useState(false);
  const [user, setUser] = useState(null);
  

  const [bdefResults, setBdefResults] = useState([]);
  const [defResults, setDefResults] = useState([]);
  

  const [bdefSearch, setBdefSearch] = useState("");
  const [defSearch, setDefSearch] = useState("");
  
 
  const [loadingBdef, setLoadingBdef] = useState(false);
  const [loadingDef, setLoadingDef] = useState(false);


  const [displayedResults, setDisplayedResults] = useState([]);
  const [selectedItems, setSelectedItems] = useState([]);
  const [email, setEmail] = useState("");

  useEffect(() => {
    const userData = localStorage.getItem("user");
    if (userData) {
      const parsedUser = JSON.parse(userData);
      setUser(parsedUser);
      loadDelegations(parsedUser);
    }
  }, []);

  const loadDelegations = async (userData) => {
    setLoading(true);
    try {
      const data = await getSecretaryDelegations(
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
    setBdefResults([]);
    setDefResults([]);
    setBdefSearch("");
    setDefSearch("");
    setDisplayedResults([]);
    setSelectedItems([]);
    setEmail("");
  };

  const handleSearchBDEF = async (searchTerm) => {
    if (!selectedDelegation || !searchTerm.trim()) {
      setBdefResults([]);
      return;
    }

    setLoadingBdef(true);
    try {
      const data = await searchBDEF(
        selectedDelegation.id_delegation,
        searchTerm, 
        user?.annee
      );
      setBdefResults(data.results || []);
      
      if (data.results && data.results.length > 0) {
        const engagements = [];
        data.results.forEach(item => {
          item.engagements.forEach(eng => {
            engagements.push({
              ...eng,
              bdef: item.bdef,
              cf_code: selectedDelegation.cf_code,
              exercice: user?.annee,
              ministere: eng.ministere || ''
            });
          });
        });
        setDisplayedResults(engagements);
        setSelectedItems([]);
      } else {
        setDisplayedResults([]);
      }
    } catch (error) {
      console.error("Erreur recherche BDEF:", error);
      setBdefResults([]);
      setDisplayedResults([]);
    } finally {
      setLoadingBdef(false);
    }
  };

  const handleSearchDEF = async (searchTerm) => {
    if (!selectedDelegation || !searchTerm.trim()) {
      setDefResults([]);
      return;
    }

    setLoadingDef(true);
    try {
      const data = await searchDEF(
        selectedDelegation.id_delegation,
        searchTerm, 
        user?.annee
      );
      setDefResults(data.results || []);
     
      if (data.results && data.results.length > 0) {
        const engagements = data.results.map(item => ({
          ...item,
          cf_code: selectedDelegation.cf_code,
          exercice: user?.annee,
          ministere: item.ministere || ''
        }));
        setDisplayedResults(engagements);
        setSelectedItems([]);
      } else {
        setDisplayedResults([]);
      }
    } catch (error) {
      console.error("Erreur recherche DEF/DEG:", error);
      setDefResults([]);
      setDisplayedResults([]);
    } finally {
      setLoadingDef(false);
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
    if (selectedItems.length === displayedResults.length && displayedResults.length > 0) {
      setSelectedItems([]);
    } else {
      setSelectedItems(displayedResults.map(item => item.id));
    }
  };

  const handleValidate = () => {
    if (selectedItems.length === 0) {
      alert("Veuillez sélectionner au moins un engagement");
      return;
    }
   
    const selectedData = displayedResults.filter(item => selectedItems.includes(item.id));
    console.log("Engagements sélectionnés:", selectedData);
    console.log("Email:", email || "Non spécifié");
    alert(`Validation envoyée pour ${selectedItems.length} engagement(s)`);
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
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-[#0B1F44] text-white shadow-lg">
        <div className="max-w-7xl mx-auto px-4 py-4">
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
      </header>

      <main className="max-w-7xl mx-auto px-4 py-6">
        {/* Sélection de la délégation */}
        <div className="mb-6">
          <DelegationSelector
            delegations={delegations}
            selectedDelegation={selectedDelegation}
            onDelegationChange={handleDelegationChange}
          />
        </div>

        {/* Sections de recherche */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <SearchSection
            title="BDEF"
            subtitle="Bon de Détail d'Engagement Financier"
            searchValue={bdefSearch}
            onSearchChange={setBdefSearch}
            onSearch={handleSearchBDEF}
            results={bdefResults}
            loading={loadingBdef}
            placeholder="Rechercher un BDEF..."
            type="bdef"
          />

          <SearchSection
            title="DEF / DEG"
            subtitle="Demande d'Engagement Financier et Global"
            searchValue={defSearch}
            onSearchChange={setDefSearch}
            onSearch={handleSearchDEF}
            results={defResults}
            loading={loadingDef}
            placeholder="Rechercher un DEF ou DEG..."
            type="def"
          />
        </div>

        {/* Tableau des résultats en bas */}
        {displayedResults.length > 0 && (
          <ResultsTable
            results={displayedResults}
            selectedItems={selectedItems}
            onToggleSelect={handleToggleSelect}
            onSelectAll={handleSelectAll}
            email={email}
            setEmail={setEmail}
            onValidate={handleValidate}
          />
        )}
      </main>
    </div>
  );
}

export default SecretaryDashboard;