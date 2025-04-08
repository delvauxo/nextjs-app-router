"use client";

import { signOut, useSession } from "next-auth/react";
import { PowerIcon } from '@heroicons/react/24/solid';

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
            + `post_logout_redirect_uri=${encodeURIComponent(process.env.NEXT_PUBLIC_NEXTAUTH_URL!)}`;

        // Redirection vers Keycloak pour déconnecter l'utilisateur côté serveur
        window.location.href = keycloakLogoutUrl;

        // Déconnexion côté client
        await signOut({ callbackUrl: "/" });
    };

    return (
        <button
            onClick={handleLogout}
            className="flex h-[48px] w-full grow items-center justify-center gap-2 rounded-md bg-red-500 p-3 text-sm font-medium hover:bg-red-400 text-white md:flex-none md:justify-start md:p-2 md:px-3"
        >
            <PowerIcon className="w-6" />
            <div className="hidden md:block">Sign Out</div>
        </button>
    );
}
