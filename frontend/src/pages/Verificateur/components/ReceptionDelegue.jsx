import { useEffect, useState } from "react";
import { getDelegateClosedEngagements, receptionDelegueEngagements } from "../../../services/verificateurService";

function ReceptionDelegue({ user }) {
  const [loading, setLoading] = useState(false);
  const [engagements, setEngagements] = useState([]);
  const [searchTerm, setSearchTerm] = useState("%");
  const [selectedItems, setSelectedItems] = useState([]);
  const [receptionLoading, setReceptionLoading] = useState(false);
  const [hasSearched, setHasSearched] = useState(false);

  useEffect(() => {
    if (user) {
      handleSearch();
    }
  }, [user]);

  const handleSearch = async () => {
    if (!user) return;

    setLoading(true);
    setHasSearched(true);
    try {
      const data = await getDelegateClosedEngagements(
        user?.immatricule,
        user?.annee,
        searchTerm || '%'
      );
      setEngagements(data.results || []);
      setSelectedItems([]);
    } catch (error) {
      console.error("Erreur chargement engagements clôturés par délégué:", error);
      setEngagements([]);
    } finally {
      setLoading(false);
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
    if (selectedItems.length === engagements.length && engagements.length > 0) {
      setSelectedItems([]);
    } else {
      setSelectedItems(engagements.map(item => item.id_del));
    }
  };

  const handleReception = async () => {
    if (selectedItems.length === 0) {
      alert("Veuillez sélectionner au moins un engagement");
      return;
    }

    const selectedData = engagements.filter(item => 
      selectedItems.includes(item.id_del)
    );

    const dataToSend = {
      immatricule: user?.immatricule,
      annee: user?.annee,
      selectedEngagements: selectedData.map(item => ({
        id_del: item.id_del,
        numDef: item.numDef,
        id_secretaire: item.id_secretaire,
        decisionfinale: item.decisionfinale,
        dateClotureDel: item.dateClotureDel
      }))
    };

    if (!window.confirm(`Confirmer la réception de ${selectedItems.length} engagement(s) clôturé(s) par le délégué ?`)) {
      return;
    }

    setReceptionLoading(true);
    try {
      const response = await receptionDelegueEngagements(dataToSend);
      
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
    };
    const color = colors[status] || "bg-gray-100 text-gray-700";
    return (
      <span className={`px-2 py-1 rounded-full text-xs font-medium ${color}`}>
        {status || "Cloturer"}
      </span>
    );
  };

  if (loading && engagements.length === 0 && hasSearched) {
    return (
      <div className="flex items-center justify-center py-12">
        <div className="text-center">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#0B1F44]"></div>
          <span className="ml-3 text-gray-500">Chargement des engagements clôturés par le délégué...</span>
        </div>
      </div>
    );
  }

  return (
    <div>
      <div className="mb-6">
        <div className="flex flex-col sm:flex-row gap-4">
          <div className="flex-1">
            <label className="block text-sm font-medium text-[#0B1F44] mb-1">
              Rechercher les engagements clôturés par le délégué
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
                disabled={loading}
                className="px-6 py-2.5 bg-[#0B1F44] text-white rounded-lg hover:bg-[#122a5c] disabled:opacity-60 disabled:cursor-not-allowed transition-colors font-medium whitespace-nowrap"
              >
                {loading ? "Recherche..." : "Rechercher"}
              </button>
            </div>
            <p className="text-xs text-gray-400 mt-1">
              Utilisez % pour afficher tous les engagements clôturés par le délégué
            </p>
          </div>
        </div>
      </div>

      {hasSearched && (
        <>
          {engagements.length === 0 ? (
            <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-12 text-center">
              <p className="text-gray-500">Aucun engagement clôturé par le délégué trouvé.</p>
            </div>
          ) : (
            <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
              <div className="px-6 py-4 bg-gray-50/80 border-b border-gray-200 flex items-center justify-between">
                <h3 className="text-lg font-semibold text-[#0B1F44]">
                  Engagements clôturés par le délégué ({engagements.length})
                </h3>
                <div className="flex items-center gap-3">
                  <span className="text-sm text-gray-500">
                    {selectedItems.length} sélectionné{selectedItems.length > 1 ? "s" : ""}
                  </span>
                  <button
                    onClick={handleReception}
                    disabled={selectedItems.length === 0 || receptionLoading}
                    className="px-6 py-2 bg-[#6FAE4F] text-white rounded-lg hover:bg-[#5d9e3f] disabled:opacity-50 disabled:cursor-not-allowed transition-colors font-medium"
                  >
                    {receptionLoading ? "Réception en cours..." : "Réceptionner"}
                  </button>
                </div>
              </div>

              <div className="overflow-x-auto">
                <table className="w-full text-sm">
                  <thead className="bg-gray-50 border-b border-gray-200">
                    <tr>
                      <th className="px-4 py-3 text-left w-10">
                        <input
                          type="checkbox"
                          checked={selectedItems.length === engagements.length && engagements.length > 0}
                          onChange={handleSelectAll}
                          className="w-4 h-4 rounded border-gray-300 text-[#0B1F44] focus:ring-[#6FAE4F]"
                        />
                      </th>
                      <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">N° DEF</th>
                      <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">BDEF</th>
                      <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">Réf CF</th>
                      <th className="px-4 py-3 text-right font-semibold text-[#0B1F44]">Montant</th>
                      <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">Décision Finale</th>
                      <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">Date clôture</th>
                      <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">Statut</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100">
                    {engagements.map((item) => (
                      <tr key={item.id_del} className="hover:bg-gray-50 transition-colors">
                        <td className="px-4 py-3">
                          <input
                            type="checkbox"
                            checked={selectedItems.includes(item.id_del)}
                            onChange={() => handleToggleSelect(item.id_del)}
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
                        <td className="px-4 py-3">
                          {getStatusBadge(item.decisionfinale)}
                        </td>
                        <td className="px-4 py-3 text-sm text-gray-600">
                          {formatDate(item.dateClotureDel)}
                        </td>
                        <td className="px-4 py-3">
                          {getStatusBadge(item.etatDelVerif)}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}
        </>
      )}
    </div>
  );
}

export default ReceptionDelegue;