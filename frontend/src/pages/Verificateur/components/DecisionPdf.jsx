import { useRef, useState } from "react";
import html2canvas from "html2canvas";
import jsPDF from "jspdf";
import logoDGCF from "../../../assets/logo.jpg";

function DecisionPdf({ decision, onClose }) {
  const pdfRef = useRef(null);
  const [exporting, setExporting] = useState(false);

  const formatDate = (dateString) => {
    if (!dateString) return "";
    try {
      const date = new Date(dateString);
      return date.toLocaleDateString("fr-FR", {
        day: "2-digit",
        month: "long",
        year: "numeric"
      });
    } catch {
      return "";
    }
  };

  const getCurrentDate = () => {
    const date = new Date();
    return date.toLocaleDateString("fr-FR", {
      day: "2-digit",
      month: "long",
      year: "numeric"
    });
  };

  const getDecisionLabel = (decisionfinale) => {
    const labels = {
      "visa": "VISA",
      "rejet": "REJET",
      "faitretour": "FAIT RETOUR"
    };
    return labels[decisionfinale?.toLowerCase()] || decisionfinale || "-";
  };

  // Le motif affiché = la décision finale prise par le délégué (del_aller1.decisionfinale),
  // accompagnée de son observation (del_aller1.decisionObs) si elle existe.
  const buildMotifText = () => {
    const label = getDecisionLabel(decision?.decisionfinale);
    let text = `Décision finale du délégué : ${label}`;

    if (decision?.decisionObs) {
      text += `\n\nObservation du délégué :\n${decision.decisionObs}`;
    }

    return text;
  };

  const exportPDF = async () => {
    const element = pdfRef.current;
    if (!element) return;

    setExporting(true);
    try {
      // Attendre que la police soit prête, sinon le texte peut être mal mesuré
      if (document.fonts && document.fonts.ready) {
        await document.fonts.ready;
      }

      // Attendre que le logo soit bien chargé avant la capture
      const img = element.querySelector("img");
      if (img && !img.complete) {
        await new Promise((resolve) => {
          img.onload = resolve;
          img.onerror = resolve;
        });
      }

      const canvas = await html2canvas(element, {
        scale: 2,
        useCORS: true,
        backgroundColor: "#ffffff",
        allowTaint: true,
        logging: false
      });

      const imgData = canvas.toDataURL("image/png");
      const pdf = new jsPDF("p", "mm", "a4");
      const pdfWidth = pdf.internal.pageSize.getWidth();
      const pdfHeight = (canvas.height * pdfWidth) / canvas.width;

      pdf.addImage(imgData, "PNG", 0, 0, pdfWidth, pdfHeight);
      pdf.save(`Decision_${decision?.numDef || "engagement"}.pdf`);
    } catch (error) {
      console.error("Erreur lors de l'export PDF:", error);
      alert("Erreur lors de la génération du PDF" + (error?.message ? " : " + error.message : ""));
    } finally {
      setExporting(false);
    }
  };

  const motifText = buildMotifText();

  return (
    <div className="fixed inset-0 bg-black/50 z-70 flex items-center justify-center p-4">
      <div className="bg-white rounded-xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto p-6">
        <div className="flex items-center justify-between mb-4 pb-4 border-b border-gray-200">
          <h3 className="text-lg font-bold text-[#0B1F44]">Aperçu PDF</h3>
          <div className="flex gap-2">
            <button
              onClick={exportPDF}
              disabled={exporting}
              className="px-4 py-2 bg-[#0B1F44] text-white rounded-lg hover:bg-[#122a5c] disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            >
              {exporting ? "Génération..." : "Exporter PDF"}
            </button>
            <button
              onClick={onClose}
              className="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
            >
              Fermer
            </button>
          </div>
        </div>

        {/* Contenu PDF - couleurs en hex explicite (pas de classes Tailwind
            gray-x ou black) pour éviter les erreurs html2canvas avec les
            fonctions de couleur type oklch que certaines versions de Tailwind génèrent. */}
        <div
          ref={pdfRef}
          className="p-8"
          style={{ width: "210mm", minHeight: "297mm", backgroundColor: "#ffffff", color: "#000000" }}
        >
          {/* En-tête avec logo */}
          <div className="text-center pb-4 mb-6" style={{ borderBottom: "1px solid #d1d5db" }}>
            <div className="flex justify-center items-center mb-2">
              <img
                src={logoDGCF}
                alt="Logo DGCF"
                className="h-24 w-auto object-contain"
                crossOrigin="anonymous"
              />
            </div>
            <div className="text-center">
              <p className="text-sm font-bold uppercase">REPOBLIKANI MADAGASIKARA</p>
              <p className="text-sm">Fitavana - Tanindrazana - Fandrosoana</p>
              <p className="text-sm font-bold mt-1">MINISTERE DE L'ECONOMIE ET DES FINANCES</p>
            </div>
          </div>

          {/* Entête avec les informations */}
          <div className="flex justify-between items-start mb-8">
            <div>
              <p className="text-sm font-bold">DIRECTION GENERALE DU CONTROLE FINANCIER</p>
              <p className="text-sm">---------------------------------------------------</p>
              <p className="text-sm font-bold">CONTROLE FINANCIER PRIMATURE</p>
            </div>
            <div className="text-right">
              <p className="text-sm">Antananarivo, le {getCurrentDate()}</p>
            </div>
          </div>

          {/* Titre principal */}
          <div className="text-center mb-8">
            <h2 className="text-xl font-bold uppercase underline">
              {getDecisionLabel(decision?.decisionfinale)}
            </h2>
          </div>

          {/* Informations */}
          <div className="space-y-4">
            <div>
              <p className="text-sm">
                <span className="font-bold">Reference :</span> {decision?.refCF || "-"}
              </p>
            </div>
            <div>
              <p className="text-sm">
                <span className="font-bold">Numero Def :</span> {decision?.numDef || "-"}
              </p>
            </div>
            <div>
              <p className="text-sm">
                <span className="font-bold">Objet :</span> {decision?.objet || "-"}
              </p>
            </div>
            <div>
              <p className="text-sm">
                <span className="font-bold">Motifs :</span>
              </p>
              <div
                className="mt-2 p-3 rounded-lg text-sm whitespace-pre-wrap"
                style={{ backgroundColor: "#f9fafb", border: "1px solid #e5e7eb" }}
              >
                {motifText}
              </div>
            </div>
          </div>

          {/* Signature */}
          <div className="mt-12 pt-8" style={{ borderTop: "1px solid #d1d5db" }}>
            <div className="text-right">
              <p className="text-sm font-bold">CONTROLE FINANCIER PRIMATURE</p>
              <p className="text-sm mt-8">(Signature)</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default DecisionPdf;