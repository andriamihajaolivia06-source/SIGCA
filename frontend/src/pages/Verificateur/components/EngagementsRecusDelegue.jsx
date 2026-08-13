import { useEffect, useState } from "react";
import { getReceivedDelegateEngagements } from "../../../services/verificateurService";
import DecisionPdf from "./DecisionPdf";

function EngagementsRecusDelegue({ user }) {
  const [loading, setLoading] = useState(false);
  const [engagements, setEngagements] = useState([]);
  const [filteredEngagements, setFilteredEngagements] = useState([]);
  const [filter, setFilter] = useState("all"); // all, visa, rejet, faitretour
  const [searchTerm, setSearchTerm] = useState("");
  
  // État pour la modal de clôture
  const [showCloseModal, setShowCloseModal] = useState(false);
  const [selectedEngagement, setSelectedEngagement] = useState(null);
  const [closing, setClosing] = useState(false);
  
  // État pour la modal PDF
  const [showPdfModal, setShowPdfModal] = useState(false);
  const [pdfDecision, setPdfDecision] = useState(null);

  useEffect(() => {
    if (user) {
      loadEngagements();
    }
  }, [user]);

  const loadEngagements = async () => {
    setLoading(true);
    try {
      const data = await getReceivedDelegateEngagements(
        user?.immatricule,
        user?.annee
      );
      setEngagements(data.results || []);
      setFilteredEngagements(data.results || []);
    } catch (error) {
      console.error("Erreur chargement engagements reçus du délégué:", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    let filtered = [...engagements];

    if (filter !== "all") {
      filtered = filtered.filter(item => 
        item.decision?.toLowerCase() === filter.toLowerCase()
      );
    }

    if (searchTerm.trim()) {
      const search = searchTerm.toLowerCase();
      filtered = filtered.filter(item =>
        (item.numDef && item.numDef.toLowerCase().includes(search)) ||
        (item.bdef && item.bdef.toLowerCase().includes(search)) ||
        (item.refCF && item.refCF.toLowerCase().includes(search)) ||
        (item.objet && item.objet.toLowerCase().includes(search))
      );
    }

    setFilteredEngagements(filtered);
  }, [engagements, filter, searchTerm]);

  const handleCloseClick = (engagement) => {
    setSelectedEngagement(engagement);
    setShowCloseModal(true);
  };

  const handleConfirmClose = async () => {
    if (!selectedEngagement) return;

    setClosing(true);
    try {
      // Appel API pour clôturer l'engagement (met à jour etatVerifDel = 'Cloturer')
      const response = await closeDelegateEngagement({
        idVerif: selectedEngagement.id_verif,
        numDef: selectedEngagement.numDef,
        immatricule: user?.immatricule
      });

      if (response.success) {
        alert("Engagement clôturé avec succès");
        setShowCloseModal(false);
        setSelectedEngagement(null);
        loadEngagements(); // Rafraîchir la liste
      } else {
        alert("Erreur lors de la clôture: " + (response.message || "Veuillez réessayer"));
      }
    } catch (error) {
      console.error("Erreur lors de la clôture:", error);
      alert("Erreur lors de la clôture. Veuillez réessayer.");
    } finally {
      setClosing(false);
    }
  };

const handlePrintClick = (engagement) => {
  const decisionData = {
    numDef: engagement.numDef,
    refCF: engagement.refCF,
    objet: engagement.objet,
    decisionfinale: engagement.decision,
    decisionObs: engagement.decisionObs || "", // Observation du délégué
    montant: engagement.montant,
    dateReception: engagement.dateReception2,
    cf_code: engagement.cf_code
  };
  setPdfDecision(decisionData);
  setShowPdfModal(true);
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

  const getDecisionBadge = (decision) => {
    const colors = {
      "visa": "bg-green-100 text-green-700",
      "rejet": "bg-red-100 text-red-700",
      "faitretour": "bg-yellow-100 text-yellow-700",
    };
    const color = colors[decision?.toLowerCase()] || "bg-gray-100 text-gray-700";
    const labels = {
      "visa": "Visa",
      "rejet": "Rejet",
      "faitretour": "Fait Retour"
    };
    return (
      <span className={`px-2 py-1 rounded-full text-xs font-medium ${color}`}>
        {labels[decision?.toLowerCase()] || decision || "-"}
      </span>
    );
  };

  if (loading && engagements.length === 0) {
    return (
      <div className="flex items-center justify-center py-12">
        <div className="text-center">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#0B1F44]"></div>
          <span className="ml-3 text-gray-500">Chargement des engagements reçus du délégué...</span>
        </div>
      </div>
    );
  }

  return (
    <div>
      <div className="mb-6">
        <div className="flex flex-col sm:flex-row gap-4 items-start sm:items-center justify-between">
          <div>
            <h2 className="text-2xl font-bold text-[#0B1F44]">Engagements Reçus du Délégué</h2>
            <p className="text-gray-500 text-sm">
              Liste des engagements déjà réceptionnés avec leur décision
            </p>
          </div>
          <div className="flex items-center gap-2">
            <input
              type="text"
              placeholder="Rechercher..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
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
      </div>

      {/* Filtres */}
      <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-4 mb-6">
        <div className="flex flex-wrap gap-2">
          <button
            onClick={() => setFilter("all")}
            className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
              filter === "all" 
                ? "bg-[#0B1F44] text-white" 
                : "bg-gray-100 text-gray-600 hover:bg-gray-200"
            }`}
          >
            Tous ({engagements.length})
          </button>
          <button
            onClick={() => setFilter("visa")}
            className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
              filter === "visa" 
                ? "bg-green-500 text-white" 
                : "bg-gray-100 text-gray-600 hover:bg-gray-200"
            }`}
          >
            Visa ({engagements.filter(e => e.decision?.toLowerCase() === "visa").length})
          </button>
          <button
            onClick={() => setFilter("rejet")}
            className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
              filter === "rejet" 
                ? "bg-red-500 text-white" 
                : "bg-gray-100 text-gray-600 hover:bg-gray-200"
            }`}
          >
            Rejet ({engagements.filter(e => e.decision?.toLowerCase() === "rejet").length})
          </button>
          <button
            onClick={() => setFilter("faitretour")}
            className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
              filter === "faitretour" 
                ? "bg-yellow-500 text-white" 
                : "bg-gray-100 text-gray-600 hover:bg-gray-200"
            }`}
          >
            Fait Retour ({engagements.filter(e => e.decision?.toLowerCase() === "faitretour").length})
          </button>
        </div>
      </div>

      {filteredEngagements.length === 0 ? (
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-12 text-center">
          <p className="text-gray-500">
            {engagements.length === 0 
              ? "Aucun engagement reçu du délégué pour le moment." 
              : "Aucun résultat ne correspond à vos critères de filtrage."}
          </p>
        </div>
      ) : (
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
          <div className="px-6 py-4 bg-gray-50/80 border-b border-gray-200 flex items-center justify-between">
            <h3 className="text-lg font-semibold text-[#0B1F44]">
              Engagements reçus du délégué ({filteredEngagements.length})
            </h3>
            <div className="flex items-center gap-3">
              <span className="text-sm text-gray-500">
                Filtre actif: {filter === "all" ? "Tous" : filter}
              </span>
              <button
                onClick={loadEngagements}
                className="px-3 py-1 text-sm bg-gray-100 text-gray-600 rounded-lg hover:bg-gray-200 transition-colors"
              >
                Rafraîchir
              </button>
            </div>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead className="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">N° DEF</th>
                  <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">BDEF</th>
                  <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">Réf CF</th>
                  <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">Objet</th>
                  <th className="px-4 py-3 text-right font-semibold text-[#0B1F44]">Montant</th>
                  <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">Décision</th>
                  <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">Date réception</th>
                  <th className="px-4 py-3 text-center font-semibold text-[#0B1F44]">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {filteredEngagements.map((item) => (
                  <tr key={item.id_verif} className="hover:bg-gray-50 transition-colors">
                    <td className="px-4 py-3 font-mono text-sm text-gray-700">
                      {item.numDef || "-"}
                    </td>
                    <td className="px-4 py-3 font-mono text-sm text-[#0B1F44]">
                      {item.bdef || "-"}
                    </td>
                    <td className="px-4 py-3 text-sm text-gray-600">
                      {item.refCF || "-"}
                    </td>
                    <td className="px-4 py-3 text-sm text-gray-600 max-w-[200px] truncate">
                      {item.objet || "-"}
                    </td>
                    <td className="px-4 py-3 text-right font-medium text-[#0B1F44]">
                      {formatMontant(item.montant)}
                    </td>
                    <td className="px-4 py-3">
                      {getDecisionBadge(item.decision)}
                    </td>
                    <td className="px-4 py-3 text-sm text-gray-600">
                      {formatDate(item.dateReception2)}
                    </td>
                    <td className="px-4 py-3 text-center">
                      <div className="flex items-center justify-center gap-2">
                        <button
                          onClick={() => handleCloseClick(item)}
                          className="px-3 py-1 bg-[#0B1F44] text-white text-xs rounded-lg hover:bg-[#122a5c] transition-colors"
                        >
                          Clôturer
                        </button>
                        <button
                          onClick={() => handlePrintClick(item)}
                          className="px-3 py-1 bg-gray-200 text-gray-700 text-xs rounded-lg hover:bg-gray-300 transition-colors"
                        >
                          Imprimer
                        </button>
                      </div>
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

      {/* Modal de confirmation de clôture */}
      {showCloseModal && selectedEngagement && (
        <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-xl shadow-2xl max-w-md w-full p-6">
            <div className="flex items-center justify-between mb-4 pb-4 border-b border-gray-200">
              <h3 className="text-lg font-bold text-[#0B1F44]">Confirmer la clôture</h3>
              <button
                onClick={() => {
                  setShowCloseModal(false);
                  setSelectedEngagement(null);
                }}
                className="text-gray-400 hover:text-gray-600 transition-colors"
              >
                ✕
              </button>
            </div>
            
            <p className="text-gray-600 mb-2">
              Voulez-vous vraiment clôturer cet engagement ?
            </p>
            <div className="bg-gray-50 rounded-lg p-3 mb-4">
              <p className="text-sm">
                <span className="font-semibold">N° DEF :</span> {selectedEngagement.numDef}
              </p>
              <p className="text-sm">
                <span className="font-semibold">Objet :</span> {selectedEngagement.objet || "-"}
              </p>
              <p className="text-sm">
                <span className="font-semibold">Décision :</span> {selectedEngagement.decision || "-"}
              </p>
            </div>

            <div className="flex justify-end gap-3">
              <button
                onClick={() => {
                  setShowCloseModal(false);
                  setSelectedEngagement(null);
                }}
                disabled={closing}
                className="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
              >
                Annuler
              </button>
              <button
                onClick={handleConfirmClose}
                disabled={closing}
                className="px-4 py-2 bg-[#0B1F44] text-white rounded-lg hover:bg-[#122a5c] disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
              >
                {closing ? "Clôture en cours..." : "Confirmer"}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Modal PDF */}
      {showPdfModal && pdfDecision && (
        <DecisionPdf
          decision={pdfDecision}
          onClose={() => {
            setShowPdfModal(false);
            setPdfDecision(null);
          }}
        />
      )}
    </div>
  );
}

export default EngagementsRecusDelegue;