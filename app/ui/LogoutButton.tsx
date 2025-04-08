"use client";

import { signOut, useSession } from "next-auth/react";
import { ArrowRightIcon } from '@heroicons/react/20/solid';

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
            className="flex items-center w-full gap-5 self-start rounded-lg bg-red-500 px-6 py-3 text-sm font-medium text-white transition-colors hover:bg-red-400 md:text-base"
        >
            <span className='w-full'>Log out</span> <ArrowRightIcon className="w-5 md:w-6" />
        </button>
    );
}
