import { useRef } from "react";
import html2canvas from "html2canvas";
import jsPDF from "jspdf";
import logoDGCF from "../../../assets/logo.jpg";

function DecisionPdf({ decision, onClose }) {
  const pdfRef = useRef(null);

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

  const getDecisionLabel = (decision) => {
    const labels = {
      "visa": "VISA",
      "rejet": "REJET",
      "faitretour": "FAIT RETOUR"
    };
    return labels[decision?.toLowerCase()] || decision || "-";
  };

  const getMotifLabel = (motif) => {
    const labels = {
      "approuver": "Approuvé",
      "nonapprouver": "Non approuvé"
    };
    return labels[motif?.toLowerCase()] || motif || "-";
  };

  const exportPDF = async () => {
    const element = pdfRef.current;
    if (!element) return;

    try {
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
      alert("Erreur lors de la génération du PDF");
    }
  };

  return (
    <div className="fixed inset-0 bg-black/50 z-70 flex items-center justify-center p-4">
      <div className="bg-white rounded-xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto p-6">
        <div className="flex items-center justify-between mb-4 pb-4 border-b border-gray-200">
          <h3 className="text-lg font-bold text-[#0B1F44]">Aperçu PDF</h3>
          <div className="flex gap-2">
            <button
              onClick={exportPDF}
              className="px-4 py-2 bg-[#0B1F44] text-white rounded-lg hover:bg-[#122a5c] transition-colors"
            >
              Exporter PDF
            </button>
            <button
              onClick={onClose}
              className="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
            >
              Fermer
            </button>
          </div>
        </div>

        {/* Contenu PDF */}
        <div ref={pdfRef} className="bg-white p-8" style={{ width: "210mm", minHeight: "297mm" }}>
          {/* En-tête avec logo */}
          <div className="text-center border-b border-gray-300 pb-4 mb-6">
            <div className="flex justify-center items-center mb-2">
              <img 
                src={logoDGCF} 
                alt="Logo DGCF" 
                className="h-50 w-50 object-contain"
                crossOrigin="anonymous"
              />
            </div>
            {/* <div className="text-center">
              <p className="text-sm font-bold uppercase">REPOBLIKANI MADAGASIKARA</p>
              <p className="text-sm">Fitavana - Tanindrazana - Fandrosoana</p>
              <p className="text-sm font-bold mt-1">MINISTERE DE L'ECONOMIE ET DES FINANCES</p>
            </div> */}
          </div>

          {/* Entete avec les informations */}
          <div className="flex justify-between items-start mb-8">
            <div>
              <p className="text-sm font-bold">DIRECTION GENERALE DU CONTROLE FINANCIER</p>
              <p>---------------------------------------------------</p>
              <p className="text-sm font-bold">CONTROLE FINANCIER PRIMATURE</p>
            </div>
            <div className="text-right">
              <p className="text-sm">Antananarivo, le {getCurrentDate()}</p>
            </div>
          </div>

          {/* Titre principal */}
          <div className="text-center mb-8">
            <h2 className="text-xl font-bold uppercase">
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
                <p>{decision?.decisionObs || "-"}</p>
              </p>
            </div>
          </div>

          {/* Signature */}
          <div className="mt-12 pt-8 border-t border-gray-300">
            <div className="text-right">
              <p className="text-sm font-bold">CONTROLE FINANCIER PRIMATURE</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default DecisionPdf;