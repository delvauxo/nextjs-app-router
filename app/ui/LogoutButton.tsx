"use client";

import { signOut, useSession } from "next-auth/react";

export default function LogoutButton() {
    const { data: session } = useSession();

    const handleLogout = async () => {
        // Vérifie si le token existe dans la session
        if (!session?.id_token) {
            console.error("ID Token is missing in the session.");
            return;
        }

        // Redirige l'utilisateur vers l'URL de déconnexion de Keycloak avec les paramètres nécessaires
        const keycloakLogoutUrl = ``
            + `${process.env.NEXT_PUBLIC_KEYCLOAK_END_SESSION_URL}?`
            + `id_token_hint=${encodeURIComponent(session.id_token)}&`
            + `post_logout_redirect_uri=${encodeURIComponent(window.location.origin + "/")}`;

        // Redirection vers Keycloak pour déconnecter l'utilisateur côté serveur
        window.location.href = keycloakLogoutUrl;

        // Déconnexion côté client (facultatif si tu veux nettoyer la session NextAuth immédiatement)
        await signOut({ callbackUrl: "/" });
    };

    return (
        <button
            onClick={handleLogout}
            className="px-4 py-2 bg-red-500 text-white rounded"
        >
            Logout
        </button>
    );
}
