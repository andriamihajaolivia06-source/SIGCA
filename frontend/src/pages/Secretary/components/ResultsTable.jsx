function ResultsTable({ 
  results, 
  selectedItems, 
  onToggleSelect, 
  onSelectAll,
  email,
  setEmail,
  onValidate
}) {
  const formatMontant = (montant) => {
    if (!montant) return "0 Ar";
    return Number(montant).toLocaleString("fr-FR") + " Ar";
  };

  const isAllSelected = results.length > 0 && selectedItems.length === results.length;

  return (
    <div className="mt-8 bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
      <div className="px-6 py-4 bg-gray-50/80 border-b border-gray-200">
        <h3 className="text-lg font-semibold text-[#0B1F44]">
          Résultats ({results.length} engagement{results.length > 1 ? "s" : ""})
        </h3>
      </div>

      <div className="overflow-x-auto">
        <table className="w-full text-sm">
          <thead className="bg-gray-50 border-b border-gray-200">
            <tr>
              <th className="px-4 py-3 text-left w-10">
                <input
                  type="checkbox"
                  checked={isAllSelected}
                  onChange={onSelectAll}
                  className="w-4 h-4 rounded border-gray-300 text-[#0B1F44] focus:ring-[#6FAE4F]"
                />
              </th>
              <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">BDEF</th>
              <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">Numéro DEF</th>
              <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">CF Code</th>
              <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">Ministère</th>
              <th className="px-4 py-3 text-right font-semibold text-[#0B1F44]">Montant</th>
              <th className="px-4 py-3 text-left font-semibold text-[#0B1F44]">Exercice</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100">
            {results.map((item) => (
              <tr key={item.id} className="hover:bg-gray-50 transition-colors">
                <td className="px-4 py-3">
                  <input
                    type="checkbox"
                    checked={selectedItems.includes(item.id)}
                    onChange={() => onToggleSelect(item.id)}
                    className="w-4 h-4 rounded border-gray-300 text-[#0B1F44] focus:ring-[#6FAE4F]"
                  />
                </td>
                <td className="px-4 py-3 font-mono text-sm text-[#0B1F44]">
                  {item.bdef || "-"}
                </td>
                <td className="px-4 py-3 font-mono text-sm text-gray-700">
                  {item.numDef || "-"}
                </td>
                <td className="px-4 py-3 text-sm text-gray-600">
                  {item.cf_code || "-"}
                </td>
                <td className="px-4 py-3 text-sm text-gray-600">
                  {item.ministere || "-"}
                </td>
                <td className="px-4 py-3 text-right font-medium text-[#0B1F44]">
                  {formatMontant(item.montant)}
                </td>
                <td className="px-4 py-3 text-sm text-gray-600">
                  {item.exercice || "-"}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Footer avec email et validation */}
      <div className="px-6 py-4 bg-gray-50/80 border-t border-gray-200">
        <div className="flex flex-col sm:flex-row items-end gap-4">
          <div className="flex-1 w-full sm:w-auto">
            <label htmlFor="email" className="block text-sm font-medium text-gray-700 mb-1">
              Adresse email (optionnel)
            </label>
            <input
              id="email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="exemple@domaine.com"
              className="w-full sm:w-80 px-4 py-2 border border-gray-200 rounded-lg focus:outline-none focus:border-[#6FAE4F] focus:ring-4 focus:ring-[#6FAE4F]/20 transition-all"
            />
          </div>
          <div className="flex items-center gap-3">
            {/* <span className="text-sm text-gray-500 whitespace-nowrap">
              {selectedItems.length} selectionne{selectedItems.length > 1 ? "s" : ""}
            </span> */}
            <button
              onClick={onValidate}
              disabled={selectedItems.length === 0}
              className="px-6 py-2 bg-[#6FAE4F] text-white rounded-lg hover:bg-[#5d9e3f] disabled:opacity-50 disabled:cursor-not-allowed transition-colors font-medium whitespace-nowrap"
            >
              Valider
            </button>
          </div>
        </div>
        {selectedItems.length === 0 && (
          <p className="text-xs text-yellow-600 mt-2">Veuillez sélectionner au moins un engagement</p>
        )}
      </div>
    </div>
  );
}

export default ResultsTable;