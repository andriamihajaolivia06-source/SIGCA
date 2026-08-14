import { ChevronDown } from "lucide-react";
import { useState, useRef, useEffect } from "react";

function DelegationSelector({ 
  delegations, 
  selectedDelegation, 
  onDelegationChange 
}) {
  const [isOpen, setIsOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState("");
  const dropdownRef = useRef(null);

  useEffect(() => {
    const handleClickOutside = (event) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
        setIsOpen(false);
      }
    };
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  const filteredDelegations = delegations.filter(d =>
    d.lib_delegation?.toLowerCase().includes(searchTerm.toLowerCase()) ||
    d.cf_code?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  if (delegations.length === 0) {
    return (
      <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4 text-yellow-700">
        <p className="font-medium">Aucune délégation assignée</p>
        <p className="text-sm">Contactez l'administrateur pour vous assigner des délégations.</p>
      </div>
    );
  }

  return (
    <div className="relative" ref={dropdownRef}>
      <label className="block text-sm font-medium text-[#0B1F44] mb-2">
        Délégation
      </label>
      
      <button
        type="button"
        onClick={() => setIsOpen(!isOpen)}
        className="w-full flex items-center justify-between bg-white border border-[#0B1F44]/20 rounded-lg px-4 py-3 text-left hover:border-[#6FAE4F] transition-colors"
      >
        <div className="flex-1 min-w-0">
          {selectedDelegation ? (
            <>
              <span className="font-medium text-[#0B1F44]">
                {selectedDelegation.cf_code}
              </span>
              <span className="ml-2 text-sm text-gray-500 truncate">
                {selectedDelegation.lib_delegation}
              </span>
              <span className="ml-2 text-xs text-gray-400">
                (ID: {selectedDelegation.id_delegation})
              </span>
            </>
          ) : (
            <span className="text-gray-400">Sélectionner une délégation</span>
          )}
        </div>
        <ChevronDown 
          className={`ml-2 flex-shrink-0 h-5 w-5 text-gray-400 transition-transform ${
            isOpen ? "rotate-180" : ""
          }`}
        />
      </button>

      {isOpen && (
        <div className="absolute z-10 mt-1 w-full bg-white border border-[#0B1F44]/20 rounded-lg shadow-xl max-h-72 overflow-hidden">
          <div className="p-2 border-b border-gray-100 sticky top-0 bg-white">
            <input
              type="text"
              placeholder="Rechercher une délégation..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full px-3 py-2 text-sm border border-gray-200 rounded-lg focus:outline-none focus:border-[#6FAE4F]"
            />
          </div>
          
          <div className="overflow-y-auto max-h-60">
            {filteredDelegations.length === 0 ? (
              <div className="px-4 py-3 text-sm text-gray-500 text-center">
                Aucune délégation trouvée
              </div>
            ) : (
              filteredDelegations.map((delegation) => (
                <button
                  key={delegation.id_delegation}
                  onClick={() => {
                    onDelegationChange(delegation);
                    setIsOpen(false);
                    setSearchTerm("");
                  }}
                  className={`w-full text-left px-4 py-3 hover:bg-gray-50 transition-colors border-b border-gray-50 last:border-0 ${
                    selectedDelegation?.id_delegation === delegation.id_delegation
                      ? "bg-[#6FAE4F]/10 border-l-4 border-[#6FAE4F]"
                      : ""
                  }`}
                >
                  <div className="font-medium text-[#0B1F44] text-sm">
                    {delegation.cf_code}
                  </div>
                  <div className="text-xs text-gray-500 truncate">
                    {delegation.lib_delegation}
                  </div>
                  <div className="text-xs text-gray-400">
                    ID: {delegation.id_delegation}
                  </div>
                </button>
              ))
            )}
          </div>
        </div>
      )}
    </div>
  );
}

export default DelegationSelector;