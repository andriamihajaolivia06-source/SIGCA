import { useState } from "react";
import { useNavigate } from "react-router-dom";

function VerificateurSidebar({ activeTab, onTabChange }) {
  const [isMobileOpen, setIsMobileOpen] = useState(false);
  const navigate = useNavigate();

  const tabs = [
    {
      id: "recherche",
      label: "Recherche des clôtures",
    },
    {
      id: "recus",
      label: "Engagements reçus",
    },
  ];

  const handleTabClick = (tabId) => {
    onTabChange(tabId);
    setIsMobileOpen(false);
  };

  const handleLogout = () => {
    localStorage.removeItem("user");
    localStorage.removeItem("token");
    navigate("/");
  };

  return (
    <>
      <button
        onClick={() => setIsMobileOpen(!isMobileOpen)}
        className="lg:hidden fixed top-20 left-4 z-50 p-2 bg-[#0B1F44] text-white rounded-lg shadow-lg"
      >
        {isMobileOpen ? "✕" : "☰"}
      </button>

      <div
        className={`
          fixed lg:sticky top-0 left-0 z-40
          w-64 h-screen bg-[#0B1F44] text-white
          transform transition-transform duration-300 ease-in-out
          ${isMobileOpen ? "translate-x-0" : "-translate-x-full"}
          lg:translate-x-0
          flex-shrink-0
        `}
      >
        <div className="flex flex-col h-full">
          <div className="p-6 border-b border-white/10">
            <h2 className="text-lg font-semibold">Navigation</h2>
          </div>

          <nav className="flex-1 p-4 space-y-2">
            {tabs.map((tab) => {
              const isActive = activeTab === tab.id;

              return (
                <button
                  key={tab.id}
                  onClick={() => handleTabClick(tab.id)}
                  className={`
                    w-full flex items-center px-4 py-3 rounded-lg
                    transition-all duration-200
                    ${
                      isActive
                        ? "bg-[#6FAE4F] text-white shadow-lg"
                        : "hover:bg-white/10 text-gray-300 hover:text-white"
                    }
                  `}
                >
                  <span className="text-sm font-medium">{tab.label}</span>
                  {isActive && (
                    <span className="ml-auto w-2 h-2 bg-white rounded-full"></span>
                  )}
                </button>
              );
            })}
          </nav>

          <div className="p-4 border-t border-white/10">
            <button
              onClick={handleLogout}
              className="w-full text-left px-4 py-3 rounded-lg
                text-gray-300 hover:text-white hover:bg-red-500/20
                transition-all duration-200"
            >
              <span className="text-sm font-medium">Déconnexion</span>
            </button>
            <p className="text-xs text-gray-400 mt-2">SIGCA v1.0</p>
          </div>
        </div>
      </div>

      {isMobileOpen && (
        <div
          className="fixed inset-0 bg-black/50 z-30 lg:hidden"
          onClick={() => setIsMobileOpen(false)}
        />
      )}
    </>
  );
}

export default VerificateurSidebar;