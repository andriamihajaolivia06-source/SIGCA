import { useState } from "react";

function SearchSection({
  title,
  subtitle,
  searchValue,
  onSearchChange,
  onSearch,
  results,
  loading,
  placeholder,
  type,
  fullWidth = false
}) {
  const handleKeyPress = (e) => {
    if (e.key === "Enter") {
      onSearch(searchValue);
    }
  };

  const getTypeColor = (type) => {
    const colors = {
      bdef: "border-blue-500",
      def: "border-green-500",
      deg: "border-purple-500"
    };
    return colors[type] || "border-gray-500";
  };

  return (
    <div className={`bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden ${
      fullWidth ? "col-span-full" : ""
    }`}>
      {/* Header */}
      <div className={`border-l-4 ${getTypeColor(type)} px-6 py-4 bg-gray-50/80`}>
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-lg font-semibold text-[#0B1F44]">{title}</h2>
            <p className="text-sm text-gray-500">{subtitle}</p>
          </div>
          <span className="text-xs bg-gray-200 px-3 py-1 rounded-full text-gray-600">
            {results.length} résultat{results.length > 1 ? "s" : ""}
          </span>
        </div>
      </div>

      {/* Barre de recherche */}
      <div className="p-4">
        <div className="flex gap-2">
          <div className="flex-1 relative">
            <input
              type="text"
              value={searchValue}
              onChange={(e) => onSearchChange(e.target.value)}
              onKeyPress={handleKeyPress}
              placeholder={placeholder}
              className="w-full px-4 py-2.5 pl-4 border border-gray-200 rounded-lg focus:outline-none focus:border-[#6FAE4F] focus:ring-4 focus:ring-[#6FAE4F]/20 transition-all"
            />
          </div>
          <button
            onClick={() => onSearch(searchValue)}
            disabled={loading || !searchValue.trim()}
            className="px-6 py-2.5 bg-[#0B1F44] text-white rounded-lg hover:bg-[#122a5c] disabled:opacity-60 disabled:cursor-not-allowed transition-colors flex items-center gap-2 font-medium whitespace-nowrap"
          >
            {loading ? (
              <>
                <span className="inline-block h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin"></span>
                Recherche...
              </>
            ) : (
              "Rechercher"
            )}
          </button>
        </div>
        {type === "bdef" && (
          <p className="text-xs text-gray-400 mt-1">
            Recherche par les 5 derniers chiffres du BDEF (ex: 22889)
          </p>
        )}
      </div>

      {/* Message d'information au lieu des resultats */}
      <div className="border-t border-gray-100 px-6 py-4 text-center text-sm text-gray-500">
        {results.length > 0 
          ? `${results.length} résultat(s) trouvé(s). Consultez le tableau ci-dessous.`
          : "Effectuez une recherche pour voir les résultats"}
      </div>
    </div>
  );
}

export default SearchSection;