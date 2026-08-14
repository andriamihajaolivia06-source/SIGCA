import { useEffect, useState } from "react";
import { getVerificationDetails, saveDelegateDecision } from "../../../services/delegateService";

function LireVerification({ engagement, onClose, onSuccess }) {
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [verification, setVerification] = useState(null);
  const [pieces, setPieces] = useState([]);
  const [motifs, setMotifs] = useState([]);
  
  // États pour les checkbox approuver/non approuver
  const [formeApprouver, setFormeApprouver] = useState(false);
  const [formeNonApprouver, setFormeNonApprouver] = useState(false);
  
  const [fondApprouver, setFondApprouver] = useState(false);
  const [fondNonApprouver, setFondNonApprouver] = useState(false);
  
  const [propositionApprouver, setPropositionApprouver] = useState(false);
  const [propositionNonApprouver, setPropositionNonApprouver] = useState(false);
  
  // États pour la proposition
  const [propositionVisa, setPropositionVisa] = useState(false);
  const [propositionRejet, setPropositionRejet] = useState(false);
  const [propositionFaitRetour, setPropositionFaitRetour] = useState(false);
  const [propositionTexte, setPropositionTexte] = useState("");
  const [propositionTexteOriginal, setPropositionTexteOriginal] = useState("");
  
  // États pour la décision finale
  const [decisionFinaleVisa, setDecisionFinaleVisa] = useState(false);
  const [decisionFinaleRejet, setDecisionFinaleRejet] = useState(false);
  const [decisionFinaleFaitRetour, setDecisionFinaleFaitRetour] = useState(false);

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
      
      if (data.verification?.observations) {
        setPropositionTexteOriginal(data.verification.observations);
        setPropositionTexte(data.verification.observations);
      }
      
      if (data.verification?.proposition === 'visa') {
        setPropositionVisa(true);
      } else if (data.verification?.proposition === 'rejet') {
        setPropositionRejet(true);
      } else if (data.verification?.proposition === 'faitretour') {
        setPropositionFaitRetour(true);
      }
      
    } catch (error) {
      console.error("Erreur chargement détails vérification:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleFormeApprouverChange = () => {
    if (!formeApprouver) {
      setFormeApprouver(true);
      setFormeNonApprouver(false);
    } else {
      setFormeApprouver(false);
    }
  };

  const handleFormeNonApprouverChange = () => {
    if (!formeNonApprouver) {
      setFormeNonApprouver(true);
      setFormeApprouver(false);
    } else {
      setFormeNonApprouver(false);
    }
  };

  const handleFondApprouverChange = () => {
    if (!fondApprouver) {
      setFondApprouver(true);
      setFondNonApprouver(false);
    } else {
      setFondApprouver(false);
    }
  };

  const handleFondNonApprouverChange = () => {
    if (!fondNonApprouver) {
      setFondNonApprouver(true);
      setFondApprouver(false);
    } else {
      setFondNonApprouver(false);
    }
  };

  const handlePropositionApprouverChange = () => {
    if (!propositionApprouver) {
      setPropositionApprouver(true);
      setPropositionNonApprouver(false);
      setPropositionTexte(propositionTexteOriginal);
    } else {
      setPropositionApprouver(false);
    }
  };

  const handlePropositionNonApprouverChange = () => {
    if (!propositionNonApprouver) {
      setPropositionNonApprouver(true);
      setPropositionApprouver(false);
      setPropositionTexte("");
    } else {
      setPropositionNonApprouver(false);
    }
  };

  const handleDecisionFinaleVisaChange = () => {
    if (!decisionFinaleVisa) {
      setDecisionFinaleVisa(true);
      setDecisionFinaleRejet(false);
      setDecisionFinaleFaitRetour(false);
    } else {
      setDecisionFinaleVisa(false);
    }
  };

  const handleDecisionFinaleRejetChange = () => {
    if (!decisionFinaleRejet) {
      setDecisionFinaleRejet(true);
      setDecisionFinaleVisa(false);
      setDecisionFinaleFaitRetour(false);
    } else {
      setDecisionFinaleRejet(false);
    }
  };

  const handleDecisionFinaleFaitRetourChange = () => {
    if (!decisionFinaleFaitRetour) {
      setDecisionFinaleFaitRetour(true);
      setDecisionFinaleVisa(false);
      setDecisionFinaleRejet(false);
    } else {
      setDecisionFinaleFaitRetour(false);
    }
  };

  const handleSave = async () => {
    // Vérifier qu'une décision finale est sélectionnée
    if (!decisionFinaleVisa && !decisionFinaleRejet && !decisionFinaleFaitRetour) {
      alert("Veuillez sélectionner une décision finale (Visa, Rejet ou Fait retour)");
      return;
    }

    // Déterminer la décision finale
    let decisionFinale = '';
    if (decisionFinaleVisa) decisionFinale = 'visa';
    else if (decisionFinaleRejet) decisionFinale = 'rejet';
    else if (decisionFinaleFaitRetour) decisionFinale = 'faitretour';

    // Déterminer les décisions de forme et fond
    let decisionForme = '';
    if (formeApprouver) decisionForme = 'approuver';
    else if (formeNonApprouver) decisionForme = 'nonapprouver';

    let decisionFond = '';
    if (fondApprouver) decisionFond = 'approuver';
    else if (fondNonApprouver) decisionFond = 'nonapprouver';

    let decisionProposition = '';
    if (propositionApprouver) decisionProposition = 'approuver';
    else if (propositionNonApprouver) decisionProposition = 'nonapprouver';

    const dataToSend = {
      id_del: engagement.id_del || 0,
      numDef: engagement.numDef,
      loginReception: JSON.parse(localStorage.getItem("user"))?.immatricule || "",
      dateReception: new Date().toISOString().split('T')[0],
      loginClotureDel: JSON.parse(localStorage.getItem("user"))?.immatricule || "",
      dateClotureDel: new Date().toISOString().split('T')[0],
      decisionforme: decisionForme,
      decisionfond: decisionFond,
      decisionfinale: decisionFinale,
      decisionObs: propositionTexte || propositionTexteOriginal || "",
      instructions: "",
      etatDelVerif: "Cloturer",
      etatVerif2: 1,
      etat: 1
    };

    if (!window.confirm("Confirmer l'enregistrement de la décision ?")) {
      return;
    }

    setSaving(true);
    try {
      const response = await saveDelegateDecision(dataToSend);
      
      if (response.success) {
        alert(`${response.message}`);
        if (onSuccess) onSuccess();
        onClose();
      } else {
        alert(`Erreur: ${response.message || 'Une erreur est survenue'}`);
      }
    } catch (error) {
      console.error("Erreur lors de l'enregistrement:", error);
      alert("Erreur lors de l'enregistrement. Veuillez réessayer.");
    } finally {
      setSaving(false);
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
    <div className="bg-white rounded-xl shadow-lg border border-gray-200 p-6 max-w-3xl w-full max-h-[90vh] overflow-y-auto">
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
          <p className="text-sm text-gray-600 mb-2">Pièces justificatives :</p>
          <div className="space-y-2 mb-3">
            {pieces.length === 0 ? (
              <p className="text-sm text-gray-400">Aucune pièce justificative</p>
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
                  {piece.checked ? (
                    <span className="text-xs text-green-600">✓ Présente</span>
                  ) : (
                    <span className="text-xs text-red-400">✗ Non présente</span>
                  )}
                </div>
              ))
            )}
          </div>
          <div className="flex gap-4 mt-3 pt-3 border-t border-gray-200">
            <label className="flex items-center gap-2 text-sm">
              <input
                type="checkbox"
                checked={formeApprouver}
                onChange={handleFormeApprouverChange}
                className="w-4 h-4 rounded border-gray-300 text-[#6FAE4F] focus:ring-[#6FAE4F]"
              />
              <span className="font-medium text-green-700">Approuver</span>
            </label>
            <label className="flex items-center gap-2 text-sm">
              <input
                type="checkbox"
                checked={formeNonApprouver}
                onChange={handleFormeNonApprouverChange}
                className="w-4 h-4 rounded border-gray-300 text-[#6FAE4F] focus:ring-[#6FAE4F]"
              />
              <span className="font-medium text-red-700">Non approuver</span>
            </label>
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
          <div className="flex gap-4 mt-3 pt-3 border-t border-gray-200">
            <label className="flex items-center gap-2 text-sm">
              <input
                type="checkbox"
                checked={fondApprouver}
                onChange={handleFondApprouverChange}
                className="w-4 h-4 rounded border-gray-300 text-[#6FAE4F] focus:ring-[#6FAE4F]"
              />
              <span className="font-medium text-green-700">Approuver</span>
            </label>
            <label className="flex items-center gap-2 text-sm">
              <input
                type="checkbox"
                checked={fondNonApprouver}
                onChange={handleFondNonApprouverChange}
                className="w-4 h-4 rounded border-gray-300 text-[#6FAE4F] focus:ring-[#6FAE4F]"
              />
              <span className="font-medium text-red-700">Non approuver</span>
            </label>
          </div>
        </div>
      </div>

      {/* 3. Section Proposition */}
      <div className="mb-6">
        <h4 className="font-semibold text-[#0B1F44] mb-3">3. Proposition</h4>
        <div className="bg-gray-50 rounded-lg p-4">
          <div className="flex flex-wrap items-center gap-4 mb-3">
            <span className="text-sm font-semibold text-gray-600">Choix du vérificateur :</span>
            <div className="flex gap-3">
              <label className="flex items-center gap-2 text-sm">
                <input
                  type="checkbox"
                  checked={propositionVisa}
                  disabled
                  className="w-4 h-4 rounded border-gray-300 text-[#6FAE4F] focus:ring-[#6FAE4F] cursor-not-allowed"
                />
                <span className={propositionVisa ? "text-green-700 font-medium" : "text-gray-400"}>
                  Visa {propositionVisa ? '✓' : ''}
                </span>
              </label>
              <label className="flex items-center gap-2 text-sm">
                <input
                  type="checkbox"
                  checked={propositionRejet}
                  disabled
                  className="w-4 h-4 rounded border-gray-300 text-[#6FAE4F] focus:ring-[#6FAE4F] cursor-not-allowed"
                />
                <span className={propositionRejet ? "text-red-700 font-medium" : "text-gray-400"}>
                  Rejet {propositionRejet ? '✓' : ''}
                </span>
              </label>
              <label className="flex items-center gap-2 text-sm">
                <input
                  type="checkbox"
                  checked={propositionFaitRetour}
                  disabled
                  className="w-4 h-4 rounded border-gray-300 text-[#6FAE4F] focus:ring-[#6FAE4F] cursor-not-allowed"
                />
                <span className={propositionFaitRetour ? "text-yellow-700 font-medium" : "text-gray-400"}>
                  Fait retour {propositionFaitRetour ? '✓' : ''}
                </span>
              </label>
            </div>
          </div>

          <div className="mb-3">
            <span className="text-sm font-semibold text-gray-600">Proposition du vérificateur :</span>
            <div className="mt-1 p-3 bg-white border border-gray-200 rounded-lg min-h-[60px] text-sm text-gray-700 whitespace-pre-wrap">
              {propositionTexteOriginal || "Aucune proposition saisie"}
            </div>
          </div>

          <div className="flex gap-4 pt-3 border-t border-gray-200">
            <label className="flex items-center gap-2 text-sm">
              <input
                type="checkbox"
                checked={propositionApprouver}
                onChange={handlePropositionApprouverChange}
                className="w-4 h-4 rounded border-gray-300 text-[#6FAE4F] focus:ring-[#6FAE4F]"
              />
              <span className="font-medium text-green-700">Approuver</span>
            </label>
            <label className="flex items-center gap-2 text-sm">
              <input
                type="checkbox"
                checked={propositionNonApprouver}
                onChange={handlePropositionNonApprouverChange}
                className="w-4 h-4 rounded border-gray-300 text-[#6FAE4F] focus:ring-[#6FAE4F]"
              />
              <span className="font-medium text-red-700">Non approuver</span>
            </label>
          </div>

          {propositionApprouver && (
            <div className="mt-3">
              <span className="text-sm font-semibold text-gray-600">Proposition approuvée :</span>
              <div className="mt-1 p-3 bg-green-50 border border-green-200 rounded-lg min-h-[60px] text-sm text-gray-700 whitespace-pre-wrap">
                {propositionTexteOriginal || "Aucune proposition"}
              </div>
            </div>
          )}

          {propositionNonApprouver && (
            <div className="mt-3">
              <label className="text-sm font-semibold text-gray-600">Nouvelle proposition :</label>
              <textarea
                value={propositionTexte}
                onChange={(e) => setPropositionTexte(e.target.value)}
                rows="3"
                className="mt-1 w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:border-[#6FAE4F] focus:ring-4 focus:ring-[#6FAE4F]/20 transition-all"
                placeholder="Saisissez une nouvelle proposition..."
              />
            </div>
          )}
        </div>
      </div>

      {/* 4. Section Décision Finale */}
      <div className="mb-6">
        <h4 className="font-semibold text-[#0B1F44] mb-3">4. Décision Finale</h4>
        <div className="bg-gray-50 rounded-lg p-4">
          <div className="flex flex-wrap gap-4">
            <label className="flex items-center gap-2 text-sm">
              <input
                type="checkbox"
                checked={decisionFinaleVisa}
                onChange={handleDecisionFinaleVisaChange}
                className="w-4 h-4 rounded border-gray-300 text-[#6FAE4F] focus:ring-[#6FAE4F]"
              />
              <span className={decisionFinaleVisa ? "text-green-700 font-medium" : "text-gray-700"}>
                Visa
              </span>
            </label>
            <label className="flex items-center gap-2 text-sm">
              <input
                type="checkbox"
                checked={decisionFinaleRejet}
                onChange={handleDecisionFinaleRejetChange}
                className="w-4 h-4 rounded border-gray-300 text-[#6FAE4F] focus:ring-[#6FAE4F]"
              />
              <span className={decisionFinaleRejet ? "text-red-700 font-medium" : "text-gray-700"}>
                Rejet
              </span>
            </label>
            <label className="flex items-center gap-2 text-sm">
              <input
                type="checkbox"
                checked={decisionFinaleFaitRetour}
                onChange={handleDecisionFinaleFaitRetourChange}
                className="w-4 h-4 rounded border-gray-300 text-[#6FAE4F] focus:ring-[#6FAE4F]"
              />
              <span className={decisionFinaleFaitRetour ? "text-yellow-700 font-medium" : "text-gray-700"}>
                Fait retour
              </span>
            </label>
          </div>
          <p className="text-xs text-gray-400 mt-2">* Sélectionnez une seule option</p>
        </div>
      </div>

      {/* Boutons de validation */}
      <div className="flex justify-end gap-3 pt-4 border-t border-gray-200">
        <button
          onClick={onClose}
          disabled={saving}
          className="px-6 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
        >
          Annuler
        </button>
        <button
          onClick={handleSave}
          disabled={saving}
          className="px-6 py-2 bg-[#0B1F44] text-white rounded-lg hover:bg-[#122a5c] disabled:opacity-60 disabled:cursor-not-allowed transition-colors"
        >
          {saving ? "Enregistrement..." : "Enregistrer"}
        </button>
      </div>
    </div>
  );
}

export default LireVerification;