import { useEffect, useState } from "react";
import { getEngagementDetails, getMotifs, saveVerification } from "../../../services/verificateurService";

function VerificationDetails({ engagement, onClose, onSuccess }) {
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  
  const [pieces, setPieces] = useState([]);
  const [allPiecesChecked, setAllPiecesChecked] = useState(false);
  
  const [formeStatus, setFormeStatus] = useState(null);
  
  const [motifs, setMotifs] = useState([]);
  const [selectedMotifIds, setSelectedMotifIds] = useState([]);
  const [fondStatus, setFondStatus] = useState(null);
  
  const [propositionVisa, setPropositionVisa] = useState(false);
  const [propositionRejet, setPropositionRejet] = useState(false);
  const [propositionFaitRetour, setPropositionFaitRetour] = useState(false);
  const [propositionTexte, setPropositionTexte] = useState("");

  useEffect(() => {
    if (engagement) {
      loadData();
    }
  }, [engagement]);

  const loadData = async () => {
    setLoading(true);
    try {
      const piecesData = await getEngagementDetails(engagement.numDef);
      setPieces(piecesData.pieces || []);
      
      const motifsData = await getMotifs();
      if (Array.isArray(motifsData)) {
        setMotifs(motifsData);
      } else if (motifsData && Array.isArray(motifsData.motifs)) {
        setMotifs(motifsData.motifs);
      } else {
        setMotifs([]);
      }
    } catch (error) {
      console.error("Erreur chargement données:", error);
      setMotifs([]);
    } finally {
      setLoading(false);
    }
  };

  const handlePieceToggle = (index) => {
    const newPieces = [...pieces];
    newPieces[index].checked = !newPieces[index].checked;
    setPieces(newPieces);
    
    const allChecked = newPieces.every(p => p.checked);
    setAllPiecesChecked(allChecked);
  };

  const setPropositionExclusive = (type) => {
    setPropositionVisa(type === 'visa');
    setPropositionRejet(type === 'rejet');
    setPropositionFaitRetour(type === 'faitretour');
  };

  const handleFormeChange = (value) => {
    if (value === 'complet') {
      const allChecked = pieces.every(p => p.checked);
      if (!allChecked) {
        alert("Toutes les pièces justificatives doivent être cochées pour valider 'Complet'");
        return;
      }
    }
    if (formeStatus === value) {
      setFormeStatus(null);
    } else {
      setFormeStatus(value);
      if (value === 'incomplet') {
        setPropositionExclusive('faitretour');
      }
    }
  };

  const handleMotifToggle = (motifId) => {
    setSelectedMotifIds(prev => {
      if (prev.includes(motifId)) {
        return prev.filter(id => id !== motifId);
      } else {
        if (motifId === 2) {
          setFondStatus('normal');
          setPropositionExclusive('visa');
        }
        return [...prev, motifId];
      }
    });
  };

  const isMotifChecked = (motifId) => {
    return selectedMotifIds.includes(motifId);
  };

  const handleFondStatusChange = (value) => {
    if (fondStatus === value) {
      setFondStatus(null);
    } else {
      setFondStatus(value);
      if (value === 'anormal') {
        setPropositionExclusive('rejet');
      } else if (value === 'normal') {
        setPropositionExclusive('visa');
      }
    }
  };

  const handlePropositionChange = (type, checked) => {
    if (type === 'visa') {
      setPropositionVisa(checked);
      if (checked) {
        setPropositionRejet(false);
        setPropositionFaitRetour(false);
      }
    } else if (type === 'rejet') {
      setPropositionRejet(checked);
      if (checked) {
        setPropositionVisa(false);
        setPropositionFaitRetour(false);
      }
    } else if (type === 'faitretour') {
      setPropositionFaitRetour(checked);
      if (checked) {
        setPropositionVisa(false);
        setPropositionRejet(false);
      }
    }
  };

  const handleSubmit = async () => {
    if (!formeStatus) {
      alert("Veuillez sélectionner un statut pour la forme");
      return;
    }
    
    if (selectedMotifIds.length === 0) {
      alert("Veuillez sélectionner au moins un motif");
      return;
    }
    
    if (!fondStatus) {
      alert("Veuillez sélectionner un statut pour le fond (Normal ou Anormal)");
      return;
    }
    
    if (!propositionVisa && !propositionRejet && !propositionFaitRetour) {
      alert("Veuillez sélectionner une proposition (Visa, Rejet ou Fait retour)");
      return;
    }
    
    if (!propositionTexte.trim()) {
      alert("Veuillez saisir une proposition");
      return;
    }

    const dataToSend = {
      id_verif: engagement.id_verif,
      id_secretaire: engagement.id_secretaire,
      numDef: engagement.numDef,
      forme: {
        status: formeStatus,
        pieces: pieces.map(p => ({ id_piece: p.id_piece, checked: p.checked }))
      },
      fond: {
        motif_ids: selectedMotifIds,
        status: fondStatus
      },
      proposition: {
        visa: propositionVisa ? 1 : 0,
        rejet: propositionRejet ? 1 : 0,
        faitretour: propositionFaitRetour ? 1 : 0,
        texte: propositionTexte
      },
      loginVerificateur: JSON.parse(localStorage.getItem("user"))?.immatricule || ""
    };

    if (!window.confirm("Confirmer la vérification de cet engagement ?")) {
      return;
    }

    setSaving(true);
    try {
      const response = await saveVerification(dataToSend);
      
      if (response.success) {
        alert(`✅ Vérification enregistrée avec succès`);
        onSuccess();
        onClose();
      } else {
        alert(`❌ Erreur: ${response.message || 'Une erreur est survenue'}`);
      }
    } catch (error) {
      console.error("Erreur lors de l'enregistrement:", error);
      alert("❌ Erreur lors de l'enregistrement. Veuillez réessayer.");
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center py-12">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#0B1F44]"></div>
        <span className="ml-3 text-gray-500">Chargement...</span>
      </div>
    );
  }

  return (
    <div className="bg-white rounded-xl shadow-lg border border-gray-200 p-6">
      <div className="flex items-center justify-between mb-6 pb-4 border-b border-gray-200">
        <div>
          <h3 className="text-lg font-bold text-[#0B1F44]">Vérification de l'engagement</h3>
          <p className="text-sm text-gray-500">DEF: {engagement?.numDef}</p>
        </div>
        <button
          onClick={onClose}
          className="text-gray-400 hover:text-gray-600 transition-colors"
        >
          ✕
        </button>
      </div>

      {/* 1. Section Forme */}
      <div className="mb-6">
        <h4 className="font-semibold text-[#0B1F44] mb-3">1. Forme</h4>
        <div className="bg-gray-50 rounded-lg p-4">
          <p className="text-sm text-gray-600 mb-3">Pièces justificatives :</p>
          <div className="space-y-2 mb-4">
            {pieces.length === 0 ? (
              <p className="text-sm text-gray-400">Aucune pièce justificative trouvée pour ce compte</p>
            ) : (
              pieces.map((piece, index) => (
                <label key={index} className="flex items-center gap-2 text-sm">
                  <input
                    type="checkbox"
                    checked={piece.checked || false}
                    onChange={() => handlePieceToggle(index)}
                    className="w-4 h-4 rounded border-gray-300 text-[#6FAE4F] focus:ring-[#6FAE4F]"
                  />
                  <span className={piece.checked ? "text-gray-700" : "text-gray-400"}>
                    {piece.pj || "Pièce"}
                  </span>
                </label>
              ))
            )}
          </div>
          <div className="flex gap-4">
            <label className="flex items-center gap-2 text-sm">
              <input
                type="checkbox"
                checked={formeStatus === 'complet'}
                onChange={() => handleFormeChange('complet')}
                className="w-4 h-4 rounded border-gray-300 text-[#6FAE4F] focus:ring-[#6FAE4F]"
                disabled={!allPiecesChecked}
              />
              <span>Complet</span>
            </label>
            <label className="flex items-center gap-2 text-sm">
              <input
                type="checkbox"
                checked={formeStatus === 'incomplet'}
                onChange={() => handleFormeChange('incomplet')}
                className="w-4 h-4 rounded border-gray-300 text-[#6FAE4F] focus:ring-[#6FAE4F]"
              />
              <span>Incomplet</span>
            </label>
          </div>
        </div>
      </div>

      {/* 2. Section Fond */}
      <div className="mb-6">
        <h4 className="font-semibold text-[#0B1F44] mb-3">2. Fond</h4>
        <div className="bg-gray-50 rounded-lg p-4">
          <div className="mb-3">
            <p className="text-sm text-gray-600 mb-2">Sélectionnez les motifs :</p>
            <div className="space-y-2 max-h-40 overflow-y-auto">
              {Array.isArray(motifs) && motifs.map((motif) => (
                <label key={motif.id_motif} className="flex items-center gap-2 text-sm">
                  <input
                    type="checkbox"
                    checked={isMotifChecked(motif.id_motif)}
                    onChange={() => handleMotifToggle(motif.id_motif)}
                    className="w-4 h-4 rounded border-gray-300 text-[#6FAE4F] focus:ring-[#6FAE4F]"
                  />
                  <span className={isMotifChecked(motif.id_motif) ? "text-gray-700" : "text-gray-400"}>
                    {motif.lib_motif}
                    {motif.id_motif === 2 && " (Rien à signaler)"}
                  </span>
                </label>
              ))}
            </div>
          </div>
          <div className="flex gap-4 mt-3">
            <label className="flex items-center gap-2 text-sm">
              <input
                type="checkbox"
                checked={fondStatus === 'normal'}
                onChange={() => handleFondStatusChange('normal')}
                className="w-4 h-4 rounded border-gray-300 text-[#6FAE4F] focus:ring-[#6FAE4F]"
              />
              <span>Normal</span>
            </label>
            <label className="flex items-center gap-2 text-sm">
              <input
                type="checkbox"
                checked={fondStatus === 'anormal'}
                onChange={() => handleFondStatusChange('anormal')}
                className="w-4 h-4 rounded border-gray-300 text-[#6FAE4F] focus:ring-[#6FAE4F]"
              />
              <span>Anormal</span>
            </label>
          </div>
        </div>
      </div>

      {/* 3. Section Proposition */}
      <div className="mb-6">
        <h4 className="font-semibold text-[#0B1F44] mb-3">3. Proposition</h4>
        <div className="bg-gray-50 rounded-lg p-4">
          <div className="flex gap-4 mb-3">
            <label className="flex items-center gap-2 text-sm">
              <input
                type="checkbox"
                checked={propositionVisa}
                onChange={(e) => handlePropositionChange('visa', e.target.checked)}
                className="w-4 h-4 rounded border-gray-300 text-[#6FAE4F] focus:ring-[#6FAE4F]"
              />
              <span>Visa</span>
            </label>
            <label className="flex items-center gap-2 text-sm">
              <input
                type="checkbox"
                checked={propositionRejet}
                onChange={(e) => handlePropositionChange('rejet', e.target.checked)}
                className="w-4 h-4 rounded border-gray-300 text-[#6FAE4F] focus:ring-[#6FAE4F]"
              />
              <span>Rejet</span>
            </label>
            <label className="flex items-center gap-2 text-sm">
              <input
                type="checkbox"
                checked={propositionFaitRetour}
                onChange={(e) => handlePropositionChange('faitretour', e.target.checked)}
                className="w-4 h-4 rounded border-gray-300 text-[#6FAE4F] focus:ring-[#6FAE4F]"
              />
              <span>Fait retour</span>
            </label>
          </div>
          <div>
            <label className="block text-sm text-gray-600 mb-1">Proposition :</label>
            <textarea
              value={propositionTexte}
              onChange={(e) => setPropositionTexte(e.target.value)}
              rows="3"
              className="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:border-[#6FAE4F] focus:ring-4 focus:ring-[#6FAE4F]/20 transition-all"
              placeholder="Saisissez votre proposition..."
            />
          </div>
        </div>
      </div>

      <div className="flex justify-end gap-3">
        <button
          onClick={onClose}
          disabled={saving}
          className="px-6 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
        >
          Annuler
        </button>
        <button
          onClick={handleSubmit}
          disabled={saving}
          className="px-6 py-2 bg-[#0B1F44] text-white rounded-lg hover:bg-[#122a5c] disabled:opacity-60 disabled:cursor-not-allowed transition-colors"
        >
          {saving ? "Enregistrement..." : "Enregistrer"}
        </button>
      </div>
    </div>
  );
}

export default VerificationDetails;