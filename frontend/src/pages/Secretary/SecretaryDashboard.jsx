import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { 
  getSecretaryDelegations, 
  searchBDEF, 
  searchDEF,
  validateEngagements
} from "../../services/secretaryService";
import logoDGCF from "../../assets/logo-dgcf.png";
import SearchSection from "./components/SearchSection";
import DelegationSelector from "./components/DelegationSelector";
import ResultsTable from "./components/ResultsTable";
import SecretarySidebar from "./components/SecretarySidebar";
import EnvoiVerificateur from "./components/EnvoiVerificateur";
import ListeClotures from "./components/ListeClotures";

function SecretaryDashboard() {
  const navigate = useNavigate();
  const [delegations, setDelegations] = useState([]);
  const [selectedDelegation, setSelectedDelegation] = useState(null);
  const [loading, setLoading] = useState(false);
  const [user, setUser] = useState(null);
  
  const [activeTab, setActiveTab] = useState("reception");
  
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

  const handleValidate = async () => {
    if (selectedItems.length === 0) {
      alert("Veuillez sélectionner au moins un engagement");
      return;
    }

    const selectedData = displayedResults.filter(item => selectedItems.includes(item.id));
    
    const dataToSend = {
      immatricule: user?.immatricule,
      annee: user?.annee,
      email: email || '',
      selectedEngagements: selectedData.map(item => ({
        id: item.id,
        numDef: item.numDef,
        refCF: selectedDelegation?.cf_code || '',
        bdef: item.bdef,
        montant: item.montant,
        ministere: item.ministere
      }))
    };

    try {
      const response = await validateEngagements(dataToSend);
      
      if (response.success) {
        alert(`✅ ${response.message}\n${response.total} engagement(s) validé(s)`);
        setSelectedItems([]);
        setDisplayedResults([]);
        setEmail("");
        setBdefResults([]);
        setDefResults([]);
        setBdefSearch("");
        setDefSearch("");
      } else {
        alert(`❌ Erreur: ${response.message || 'Une erreur est survenue'}`);
      }
    } catch (error) {
      console.error("Erreur lors de la validation:", error);
      alert("❌ Erreur lors de la validation. Veuillez réessayer.");
    }
  };

  const renderContent = () => {
    switch (activeTab) {
      case "reception":
        return (
          <>
            <div className="mb-6">
              <DelegationSelector
                delegations={delegations}
                selectedDelegation={selectedDelegation}
                onDelegationChange={handleDelegationChange}
              />
            </div>

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
          </>
        );

      case "envoi":
        return <EnvoiVerificateur user={user} />;

      case "liste":
        return <ListeClotures user={user} />;

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
      <SecretarySidebar activeTab={activeTab} onTabChange={setActiveTab} />

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

        <main className="p-6">
          {renderContent()}
        </main>
      </div>
    </div>
  );
}

export default SecretaryDashboard;