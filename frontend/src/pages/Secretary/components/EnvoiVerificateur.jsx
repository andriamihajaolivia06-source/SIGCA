import { useEffect, useState } from "react";
import { getValidatedEngagements, closeEngagements } from "../../../services/secretaryService";

function EnvoiVerificateur({ user }) {
  const [loading, setLoading] = useState(false);
  const [engagements, setEngagements] = useState([]);
  const [selectedItems, setSelectedItems] = useState([]);
  const [searchTerm, setSearchTerm] = useState("");

  useEffect(() => {
    if (user) {
      loadEngagements();
    }
  }, [user]);

  const loadEngagements = async () => {
    setLoading(true);
    try {
      const data = await getValidatedEngagements(
        user?.immatricule,
        user?.annee
      );
      setEngagements(data.results || []);
    } catch (error) {
      console.error("Erreur chargement engagements validés:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleSearch = (e) => {
    setSearchTerm(e.target.value);
  };

  const filteredEngagements = engagements.filter(item => {
    if (!searchTerm.trim()) return true;
    const search = searchTerm.toLowerCase();
    return (
      (item.numDef && item.numDef.toLowerCase().includes(search)) ||
      (item.bdef && item.bdef.toLowerCase().includes(search)) ||
      (item.refCF && item.refCF.toLowerCase().includes(search)) ||
      (item.objet && item.objet.toLowerCase().includes(search))
    );
  });

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
    if (selectedItems.length === filteredEngagements.length && filteredEngagements.length > 0) {
      setSelectedItems([]);
    } else {
      setSelectedItems(filteredEngagements.map(item => item.id_secretaire));
    }
  };

  const handleClose = async () => {
    if (selectedItems.length === 0) {
      alert("Veuillez sélectionner au moins un engagement");
      return;
    }

    const selectedData = filteredEngagements.filter(item => 
      selectedItems.includes(item.id_secretaire)
    );

    const dataToSend = {
      immatricule: user?.immatricule,
      annee: user?.annee,
      selectedEngagements: selectedData.map(item => ({
        id_secretaire: item.id_secretaire,
        numDef: item.numDef
      }))
    };

    if (!window.confirm(`Confirmer la clôture de ${selectedItems.length} engagement(s) vers le vérificateur ?`)) {
      return;
    }

    setLoading(true);
    try {
      const response = await closeEngagements(dataToSend);
      
      if (response.success) {
        alert(`✅ ${response.message}\n${response.total} engagement(s) clôturé(s)`);
        setSelectedItems([]);
        loadEngagements();
      } else {
        alert(`❌ Erreur: ${response.message || 'Une erreur est survenue'}`);
      }
    } catch (error) {
      console.error("Erreur lors de la clôture:", error);
      alert("❌ Erreur lors de la clôture. Veuillez réessayer.");
    } finally {
      setLoading(false);
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

  const getStatusBadge = (status) => {
    const colors = {
      "En attente": "bg-yellow-100 text-yellow-700",
      "Cloturer": "bg-green-100 text-green-700",
      "Rejete": "bg-red-100 text-red-700",
    };
    const color = colors[status] || "bg-gray-100 text-gray-700";
    return (
      <span className={`px-2 py-1 rounded-full text-xs font-medium ${color}`}>
        {status || "En attente"}
      </span>
    );
  };

  if (loading && engagements.length === 0) {
    return (
      <div className="flex items-center justify-center py-12">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-[#0B1F44] mx-auto"></div>
          <p className="mt-4 text-gray-600">Chargement des engagements...</p>
        </div>
      </div>
    );
  }

  return (
    <div>
      <div className="mb-6 flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold text-[#0B1F44]">Envoie vers Verificateur</h2>
          <p className="text-gray-500 text-sm">Liste des engagements validés à envoyer au vérificateur</p>
        </div>
        <div className="flex items-center gap-2">
          <input
            type="text"
            placeholder="Rechercher..."
            value={searchTerm}
            onChange={handleSearch}
            className="px-4 py-2 w-64 border border-gray-200 rounded-lg focus:outline-none focus:border-[#6FAE4F] focus:ring-4 focus:ring-[#6FAE4F]/20 transition-all"
          />
          {searchTerm && (
            <button
              onClick={() => setSearchTerm("")}
              className="px-3 py-2 text-gray-500 hover:text-gray-700 transition-colors"
            >
              ✕
            </button>
          )}
        </div>
      </div>

      {engagements.length === 0 ? (
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-12 text-center">
          <p className="text-gray-500">Aucun engagement validé à envoyer au vérificateur.</p>
        </div>
      ) : (
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
          <div className="px-6 py-4 bg-gray-50/80 border-b border-gray-200 flex items-center justify-between">
            <h3 className="text-lg font-semibold text-[#0B1F44]">
              Engagements validés ({filteredEngagements.length})
            </h3>
            <div className="flex items-center gap-3">
              <span className="text-sm text-gray-500">
                {selectedItems.length} sélectionné{selectedItems.length > 1 ? "s" : ""}
              </span>
              <button
                onClick={handleClose}
                disabled={selectedItems.length === 0 || loading}
                className="px-6 py-2 bg-[#6FAE4F] text-white rounded-lg hover:bg-[#5d9e3f] disabled:opacity-50 disabled:cursor-not-allowed transition-colors font-medium"
              >
                {loading ? "Clôture en cours..." : "Clôturer"}
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
                      checked={selectedItems.length === filteredEngagements.length && filteredEngagements.length > 0}
                      onChange={handleSelectAll}
                      className="w-4 h-4 rounded border-gray-300 text-[#0B1F44] focus:ring-[#6FAE4F]"
                    />
                  </th>
                  <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">N° DEF</th>
                  <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">BDEF</th>
                  <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">Réf CF</th>
                  <th className="px-4 py-3 text-right font-semibold text-[#0B1F44]">Montant</th>
                  <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">Date réception</th>
                  <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">Statut</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {filteredEngagements.map((item) => (
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
                      {item.montant ? Number(item.montant).toLocaleString("fr-FR") + " Ar" : "0 Ar"}
                    </td>
                    <td className="px-4 py-3 text-sm text-gray-600">
                      {formatDate(item.dateReception1)}
                    </td>
                    <td className="px-4 py-3">
                      {getStatusBadge(item.etatSecVerif)}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {filteredEngagements.length < engagements.length && (
            <div className="px-6 py-3 bg-gray-50/80 border-t border-gray-200 text-sm text-gray-500">
              {filteredEngagements.length} résultat(s) affiché(s) sur {engagements.length} total
            </div>
          )}
        </div>
      )}
    </div>
  );
}

export default EnvoiVerificateur;