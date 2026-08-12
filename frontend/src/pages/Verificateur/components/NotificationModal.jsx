import { useState } from "react";

function NotificationModal({ notifications, user, onClose, onNotificationClick, onRefresh }) {
  const [filter, setFilter] = useState("all");

  const filteredNotifications = notifications.filter(n => {
    if (filter === "unread") return n.etatVerif2 === 0;
    if (filter === "read") return n.etatVerif2 === 1;
    return true;
  });

  const formatDate = (dateString) => {
    if (!dateString) return "";
    try {
      const date = new Date(dateString);
      return date.toLocaleDateString("fr-FR") + " " + date.toLocaleTimeString("fr-FR");
    } catch {
      return "";
    }
  };

  const getStatusBadge = (status) => {
    const colors = {
      "visa": "bg-green-100 text-green-700",
      "rejet": "bg-red-100 text-red-700",
      "faitretour": "bg-yellow-100 text-yellow-700",
    };
    const color = colors[status?.toLowerCase()] || "bg-gray-100 text-gray-700";
    return (
      <span className={`px-2 py-0.5 rounded-full text-xs font-medium ${color}`}>
        {status || "-"}
      </span>
    );
  };

  return (
    <div className="p-6">
      <div className="flex items-center justify-between mb-4 pb-4 border-b border-gray-200">
        <div className="flex items-center gap-3">
          <h2 className="text-xl font-bold text-[#0B1F44]">Notifications</h2>
        </div>
        <button
          onClick={onClose}
          className="text-gray-400 hover:text-gray-600 transition-colors"
        >
          ✕
        </button>
      </div>

      {filteredNotifications.length === 0 ? (
        <div className="text-center py-12 text-gray-500">
          <p>Aucune notification</p>
        </div>
      ) : (
        <div className="space-y-3 max-h-[60vh] overflow-y-auto">
          {filteredNotifications.map((notification) => (
            <div
              key={notification.id_del}
              onClick={() => onNotificationClick(notification)}
              className={`
                p-4 rounded-lg border cursor-pointer transition-colors
                ${notification.etatVerif2 === 1 
                  ? 'bg-white border-gray-200 hover:bg-gray-50' 
                  : 'bg-blue-50 border-blue-200 hover:bg-blue-100'
                }
              `}
            >
              <div className="flex items-start justify-between">
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2 flex-wrap">
                    <span className="font-semibold text-[#0B1F44]">
                      {notification.numDef}
                    </span>
                    {notification.etatVerif2 === 0 && (
                      <span className="px-2 py-0.5 bg-blue-500 text-white text-xs rounded-full">
                        Nouveau
                      </span>
                    )}
                    {getStatusBadge(notification.decisionfinale)}
                  </div>
                  <p className="text-sm text-gray-600 mt-1 line-clamp-2">
                    {notification.objet || "Sans objet"}
                  </p>
                  <div className="flex items-center gap-4 mt-2 text-xs text-gray-500">
                    <span>Décision finale: <strong>{notification.decisionfinale || "-"}</strong></span>
                    <span>Date: {formatDate(notification.dateClotureDel)}</span>
                    <span>Délégué: {notification.loginReception || "-"}</span>
                  </div>
                </div>
                {notification.etatVerif2 === 0 && (
                  <div className="ml-4 flex-shrink-0">
                    <span className="inline-block w-2 h-2 bg-blue-500 rounded-full"></span>
                  </div>
                )}
              </div>
            </div>
          ))}
        </div>
      )}

      <div className="mt-4 pt-4 border-t border-gray-200 flex justify-between">
        <span className="text-sm text-gray-500">
          Total: {notifications.length} notification{notifications.length > 1 ? "s" : ""}
        </span>
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

export default NotificationModal;