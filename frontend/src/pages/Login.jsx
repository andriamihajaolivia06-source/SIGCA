import { useEffect, useState } from "react";
import { getAuthOptions, login } from "../services/authService";
import logoDGCF from "../assets/logo-dgcf.png";

function Login() {
  const [annees, setAnnees] = useState([]);
  const [roles, setRoles] = useState([]);

  const [form, setForm] = useState({
    annee: "",
    immatricule: "",
    motDePasse: "",
    role: "",
  });

  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    const chargerOptions = async () => {
      try {
        const data = await getAuthOptions();

        setAnnees(data.annees || []);
        setRoles(data.roles || []);
      } catch (error) {
        setError("Impossible de charger les informations.");
      }
    };

    chargerOptions();
  }, []);

  const handleChange = (event) => {
    setForm({
      ...form,
      [event.target.name]: event.target.value,
    });

    setError("");
  };

  const handleSubmit = async (event) => {
    event.preventDefault();

    setError("");

    if (
      !form.annee ||
      !form.immatricule ||
      !form.motDePasse ||
      !form.role
    ) {
      setError("Veuillez remplir tous les champs.");
      return;
    }

    setLoading(true);

    try {
      const data = await login(form);

      console.log("Connexion réussie :", data.user);

    } catch (error) {
      setError(
        error.response?.data?.messages?.error ||
          "Immatricule, mot de passe, année ou rôle incorrect."
      );
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-white flex items-center justify-center px-4">

      <div className="w-full max-w-md">

        {/* Logo */}


        {/* Carte de connexion */}
        <div className="rounded-2xl border border-[#0B1F44]/10 bg-white p-8 shadow-xl">

        <div className="mb-8 flex flex-col items-center text-center">

          <div className="mb-4 flex items-center justify-center gap-3">
            <img
              src={logoDGCF}
              alt="Logo DGCF"
              className="h-14 w-14 object-contain"
            />
            <span className="text-3xl font-bold tracking-wide text-[#0B1F44]">
              SIGCA
            </span>
          </div>

        </div>

          <form onSubmit={handleSubmit} className="space-y-5">

            {/* Année */}
            <div>
              <label
                htmlFor="annee"
                className="mb-2 block text-sm font-medium text-[#0B1F44]"
              >
                Année d'exercice
              </label>

              <select
                id="annee"
                name="annee"
                value={form.annee}
                onChange={handleChange}
                className="w-full rounded-lg border border-[#0B1F44]/20 bg-white px-4 py-3 text-sm text-[#0B1F44] outline-none transition focus:border-[#6FAE4F] focus:ring-4 focus:ring-[#6FAE4F]/20"
              >
                <option value="">
                  Sélectionner une année
                </option>

                {annees.map((annee) => (
                  <option key={annee} value={annee}>
                    {annee}
                  </option>
                ))}
              </select>
            </div>

            {/* Immatricule */}
            <div>
              <label
                htmlFor="immatricule"
                className="mb-2 block text-sm font-medium text-[#0B1F44]"
              >
                Immatricule
              </label>

              <input
                id="immatricule"
                type="text"
                name="immatricule"
                value={form.immatricule}
                onChange={handleChange}
                placeholder="Entrez votre immatricule"
                className="w-full rounded-lg border border-[#0B1F44]/20 px-4 py-3 text-sm text-[#0B1F44] outline-none transition placeholder:text-slate-400 focus:border-[#6FAE4F] focus:ring-4 focus:ring-[#6FAE4F]/20"
              />
            </div>

            {/* Mot de passe */}
            <div>
              <label
                htmlFor="motDePasse"
                className="mb-2 block text-sm font-medium text-[#0B1F44]"
              >
                Mot de passe
              </label>

              <input
                id="motDePasse"
                type="password"
                name="motDePasse"
                value={form.motDePasse}
                onChange={handleChange}
                placeholder="Entrez votre mot de passe"
                className="w-full rounded-lg border border-[#0B1F44]/20 px-4 py-3 text-sm text-[#0B1F44] outline-none transition placeholder:text-slate-400 focus:border-[#6FAE4F] focus:ring-4 focus:ring-[#6FAE4F]/20"
              />
            </div>

            {/* Rôle */}
            <div>
              <label
                htmlFor="role"
                className="mb-2 block text-sm font-medium text-[#0B1F44]"
              >
                Rôle
              </label>

              <select
                id="role"
                name="role"
                value={form.role}
                onChange={handleChange}
                className="w-full rounded-lg border border-[#0B1F44]/20 bg-white px-4 py-3 text-sm text-[#0B1F44] outline-none transition focus:border-[#6FAE4F] focus:ring-4 focus:ring-[#6FAE4F]/20"
              >
                <option value="">
                  Sélectionner votre rôle
                </option>

                {roles.map((role) => (
                  <option key={role} value={role}>
                    {role.charAt(0).toUpperCase() + role.slice(1)}
                  </option>
                ))}
              </select>
            </div>

            {/* Message d'erreur */}
            {error && (
              <div className="rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-600">
                {error}
              </div>
            )}

            {/* Bouton */}
            <button
              type="submit"
              disabled={loading}
              className="w-full rounded-lg bg-[#0B1F44] px-4 py-3 text-sm font-semibold text-white shadow-md transition hover:bg-[#122a5c] focus:outline-none focus:ring-4 focus:ring-[#6FAE4F]/30 disabled:cursor-not-allowed disabled:opacity-60"
            >
              {loading ? "Connexion..." : "Se connecter"}
            </button>

          </form>

          {/* Footer */}
          <div className="mt-7 border-t border-[#0B1F44]/10 pt-5 text-center">
            <p className="text-xs font-medium text-[#6FAE4F]">
              SIG Contrôle A Priori
            </p>
          </div>

        </div>

      </div>

    </div>
  );
}

export default Login;