import { useEffect, useState } from "react";
import { getReceivedEngagements } from "../../../services/verificateurService";
import VerificationDetails from "./VerificationDetails"; 

function EngagementsRecus({ user }) {
  const [loading, setLoading] = useState(false);
  const [engagements, setEngagements] = useState([]);
  const [searchTerm, setSearchTerm] = useState("");
  
  const [selectedEngagement, setSelectedEngagement] = useState(null);
  const [showModal, setShowModal] = useState(false);

  useEffect(() => {
    if (user) {
      loadEngagements();
    }
  }, [user]);

  const loadEngagements = async () => {
    setLoading(true);
    try {
      const data = await getReceivedEngagements(
        user?.immatricule,
        user?.annee
      );
      setEngagements(data.results || []);
    } catch (error) {
      console.error("Erreur chargement engagements reçus:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleSearch = (e) => {
    setSearchTerm(e.target.value);
  };

  const handleOpenVerification = (engagement) => {
    setSelectedEngagement(engagement);
    setShowModal(true);
  };

  const handleCloseModal = () => {
    setShowModal(false);
    setSelectedEngagement(null);
  };

  const handleVerificationSuccess = () => {
    loadEngagements();
  };

  const filteredEngagements = engagements.filter(item => {
    if (!searchTerm.trim()) return true;
    const search = searchTerm.toLowerCase();
    return (
      (item.numDef && item.numDef.toLowerCase().includes(search)) ||
      (item.bdef && item.bdef.toLowerCase().includes(search)) ||
      (item.refCF && item.refCF.toLowerCase().includes(search))
    );
  });

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
      "Noncloturer": "bg-yellow-100 text-yellow-700",
      "Cloturer": "bg-green-100 text-green-700",
    };
    const color = colors[status] || "bg-gray-100 text-gray-700";
    return (
      <span className={`px-2 py-1 rounded-full text-xs font-medium ${color}`}>
        {status || "Noncloturer"}
      </span>
    );
  };

  if (loading && engagements.length === 0) {
    return (
      <div className="flex items-center justify-center py-12">
        <div className="text-center">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#0B1F44]"></div>
          <span className="ml-3 text-gray-500">Chargement des engagements reçus...</span>
        </div>
      </div>
    );
  }

  return (
    <div>
      <div className="mb-6 flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold text-[#0B1F44]">Engagements Reçus</h2>
          <p className="text-gray-500 text-sm">Liste des engagements réceptionnés à vérifier</p>
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
          <p className="text-gray-500">Aucun engagement reçu pour le moment.</p>
        </div>
      ) : (
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
          <div className="px-6 py-4 bg-gray-50/80 border-b border-gray-200 flex items-center justify-between">
            <h3 className="text-lg font-semibold text-[#0B1F44]">
              Engagements reçus ({filteredEngagements.length})
            </h3>
            <span className="text-sm text-gray-500">
              Total: {engagements.length}
            </span>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead className="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">N° DEF</th>
                  <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">BDEF</th>
                  <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">Réf CF</th>
                  <th className="px-4 py-3 text-right font-semibold text-[#0B1F44]">Montant</th>
                  <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">Date réception</th>
                  <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">Statut</th>
                  <th className="px-4 py-3 text-center font-semibold text-[#0B1F44]">Action</th>
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
                    <td className="px-4 py-3 text-right font-medium text-[#0B1F44]">
                      {formatMontant(item.montant)}
                    </td>
                    <td className="px-4 py-3 text-sm text-gray-600">
                      {formatDate(item.dateReception)}
                    </td>
                    <td className="px-4 py-3">
                      {getStatusBadge(item.etatVerifDel)}
                    </td>
                    <td className="px-4 py-3 text-center">
                      <button
                        onClick={() => handleOpenVerification(item)}
                        className="px-4 py-1.5 bg-[#6FAE4F] text-white text-xs rounded-lg hover:bg-[#5d9e3f] transition-colors"
                      >
                        Vérifier
                      </button>
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

      {/* Modal de vérification */}
      {showModal && selectedEngagement && (
        <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            <VerificationDetails
              engagement={selectedEngagement}
              onClose={handleCloseModal}
              onSuccess={handleVerificationSuccess}
            />
          </div>
        </div>
      )}
    </div>
  );
}

export default EngagementsRecus;