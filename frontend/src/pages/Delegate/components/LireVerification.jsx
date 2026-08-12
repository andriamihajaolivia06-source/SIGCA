import { useEffect, useState } from "react";
import { getVerificationDetails } from "../../../services/delegateService";

function LireVerification({ engagement, onClose }) {
  const [loading, setLoading] = useState(false);
  const [verification, setVerification] = useState(null);
  const [pieces, setPieces] = useState([]);
  const [motifs, setMotifs] = useState([]);

  useEffect(() => {
    if (engagement) {
      loadVerificationData();
    }
  }, [engagement]);

  const loadVerificationData = async () => {
    setLoading(true);
    try {
      const data = await getVerificationDetails(engagement.numDef);
      setVerification(data.verification);
      setPieces(data.pieces || []);
      setMotifs(data.motifs || []);
    } catch (error) {
      console.error("Erreur chargement détails vérification:", error);
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

  const formatMontant = (montant) => {
    if (!montant) return "0 Ar";
    return Number(montant).toLocaleString("fr-FR") + " Ar";
  };

  const getStatusBadge = (status) => {
    const colors = {
      "complet": "bg-green-100 text-green-700",
      "incomplet": "bg-yellow-100 text-yellow-700",
      "faitretour": "bg-red-100 text-red-700",
      "normal": "bg-green-100 text-green-700",
      "anormal": "bg-red-100 text-red-700",
      "visa": "bg-green-100 text-green-700",
      "rejet": "bg-red-100 text-red-700",
    };
    const color = colors[status?.toLowerCase()] || "bg-gray-100 text-gray-700";
    return (
      <span className={`px-2 py-1 rounded-full text-xs font-medium ${color}`}>
        {status || "-"}
      </span>
    );
  };

  const getMotifLabel = (id) => {
    const motif = motifs.find(m => m.id_motif === id);
    return motif ? motif.lib_motif : id;
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center py-12">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#0B1F44]"></div>
        <span className="ml-3 text-gray-500">Chargement des détails...</span>
      </div>
    );
  }

  if (!verification) {
    return (
      <div className="bg-white rounded-xl shadow-lg border border-gray-200 p-6 text-center">
        <p className="text-gray-500">Aucune vérification trouvée pour cet engagement.</p>
        <button
          onClick={onClose}
          className="mt-4 px-6 py-2 bg-[#0B1F44] text-white rounded-lg hover:bg-[#122a5c] transition-colors"
        >
          Fermer
        </button>
      </div>
    );
  }

  return (
    <div className="bg-white rounded-xl shadow-lg border border-gray-200 p-6 max-w-2xl w-full max-h-[90vh] overflow-y-auto">
      <div className="flex items-center justify-between mb-6 pb-4 border-b border-gray-200">
        <div>
          <h3 className="text-lg font-bold text-[#0B1F44]">Détails de la Vérification</h3>
          <p className="text-sm text-gray-500">DEF: {verification.numDef}</p>
        </div>
        <button
          onClick={onClose}
          className="text-gray-400 hover:text-gray-600 transition-colors"
        >
          ✕
        </button>
      </div>

      {/* Informations générales */}
      <div className="mb-6 bg-gray-50 rounded-lg p-4">
        <div className="grid grid-cols-2 gap-2 text-sm">
          <span className="font-semibold text-gray-600">BDEF :</span>
          <span className="text-gray-800">{verification.bdef || "-"}</span>
          <span className="font-semibold text-gray-600">Réf CF :</span>
          <span className="text-gray-800">{verification.refCF || "-"}</span>
          <span className="font-semibold text-gray-600">Montant :</span>
          <span className="text-gray-800 font-medium">{formatMontant(verification.montant)}</span>
          <span className="font-semibold text-gray-600">Objet :</span>
          <span className="text-gray-800">{verification.objet || "-"}</span>
          <span className="font-semibold text-gray-600">Date réception :</span>
          <span className="text-gray-800">{formatDate(verification.dateReception)}</span>
          <span className="font-semibold text-gray-600">Vérifié par :</span>
          <span className="text-gray-800">{verification.loginReception || "-"}</span>
        </div>
      </div>

      {/* 1. Section Forme */}
      <div className="mb-6">
        <h4 className="font-semibold text-[#0B1F44] mb-3">1. Forme</h4>
        <div className="bg-gray-50 rounded-lg p-4">
          <div className="flex items-center gap-4 mb-3">
            <span className="text-sm font-semibold text-gray-600">Statut :</span>
            {getStatusBadge(verification.forme)}
            <span className="text-sm text-gray-500">
              ({verification.forme === 'complet' ? 'Toutes les pièces sont présentes' : 
                verification.forme === 'incomplet' ? 'Certaines pièces sont manquantes' : 
                verification.forme === 'faitretour' ? 'Retour pour complément' : verification.forme})
            </span>
          </div>
          <p className="text-sm text-gray-600 mb-2">Pièces justificatives vérifiées :</p>
          <div className="space-y-2">
            {pieces.length === 0 ? (
              <p className="text-sm text-gray-400">Aucune pièce justificative vérifiée</p>
            ) : (
              pieces.map((piece, index) => (
                <div key={index} className="flex items-center gap-2 text-sm">
                  <input
                    type="checkbox"
                    checked={piece.checked || false}
                    disabled
                    className="w-4 h-4 rounded border-gray-300 text-[#6FAE4F] focus:ring-[#6FAE4F] cursor-not-allowed"
                  />
                  <span className={piece.checked ? "text-gray-700" : "text-gray-400"}>
                    {piece.pj || "Pièce"}
                  </span>
                  {piece.checked && (
                    <span className="text-xs text-green-600">✓ Présente</span>
                  )}
                </div>
              ))
            )}
          </div>
        </div>
      </div>

      {/* 2. Section Fond */}
      <div className="mb-6">
        <h4 className="font-semibold text-[#0B1F44] mb-3">2. Fond</h4>
        <div className="bg-gray-50 rounded-lg p-4">
          <div className="flex items-center gap-4 mb-3">
            <span className="text-sm font-semibold text-gray-600">Statut :</span>
            {getStatusBadge(verification.fond)}
            <span className="text-sm text-gray-500">
              ({verification.fond === 'normal' ? 'Fond normal' : 
                verification.fond === 'anormal' ? 'Anomalie détectée' : verification.fond})
            </span>
          </div>
          <div className="flex items-center gap-4">
            <span className="text-sm font-semibold text-gray-600">Motif(s) :</span>
            <div className="flex flex-wrap gap-2">
              {verification.motif_ids && verification.motif_ids.length > 0 ? (
                verification.motif_ids.map((id) => (
                  <span key={id} className="px-2 py-1 bg-gray-200 rounded-full text-xs text-gray-700">
                    {getMotifLabel(id)}
                  </span>
                ))
              ) : (
                <span className="text-sm text-gray-400">Aucun motif sélectionné</span>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* 3. Section Proposition */}
      <div className="mb-6">
        <h4 className="font-semibold text-[#0B1F44] mb-3">3. Proposition</h4>
        <div className="bg-gray-50 rounded-lg p-4">
          <div className="flex flex-wrap items-center gap-4 mb-3">
            <span className="text-sm font-semibold text-gray-600">Choix :</span>
            <div className="flex gap-3">
              <span className={`px-3 py-1 rounded-full text-xs font-medium ${
                verification.proposition === 'visa' ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-400'
              }`}>
                Visa {verification.proposition === 'visa' ? '✓' : ''}
              </span>
              <span className={`px-3 py-1 rounded-full text-xs font-medium ${
                verification.proposition === 'rejet' ? 'bg-red-100 text-red-700' : 'bg-gray-100 text-gray-400'
              }`}>
                Rejet {verification.proposition === 'rejet' ? '✓' : ''}
              </span>
              <span className={`px-3 py-1 rounded-full text-xs font-medium ${
                verification.proposition === 'faitretour' ? 'bg-yellow-100 text-yellow-700' : 'bg-gray-100 text-gray-400'
              }`}>
                Fait retour {verification.proposition === 'faitretour' ? '✓' : ''}
              </span>
            </div>
          </div>
          <div>
            <span className="text-sm font-semibold text-gray-600">Observations :</span>
            <p className="mt-1 text-sm text-gray-700 whitespace-pre-wrap">
              {verification.observations || "Aucune observation saisie"}
            </p>
          </div>
          <div className="mt-2">
            <span className="text-sm font-semibold text-gray-600">Statut de la vérification :</span>
            <span className="ml-2 text-sm text-gray-700">
              {verification.etatVerifDel || "-"}
            </span>
          </div>
        </div>
      </div>

      {/* Bouton de fermeture */}
      <div className="flex justify-end pt-4 border-t border-gray-200">
        <button
          onClick={onClose}
          className="px-6 py-2 bg-[#0B1F44] text-white rounded-lg hover:bg-[#122a5c] transition-colors"
        >
          Fermer
        </button>
      </div>
    </div>
  );
}

export default LireVerification;