'use client';

// RECUPERER DATA USER (token_id, nom, mail)

import { signOut, useSession } from "next-auth/react";
import { PowerIcon } from '@heroicons/react/24/solid';

export default function ButtonSignout() {

    const { data: session } = useSession();

    const handleSignout = async () => {

        // Vérifie si le token existe dans la session
        if (!session?.id_token) {
            console.error('ID Token is missing in the session');
            return;
        }

        // Redirige l'utilisateur vers l'URL de déconnexion de Keycloak avec les paramètres nécessaires
        const keycloakSignoutUrl = ``
            + `${process.env.NEXT_PUBLIC_KEYCLOAK_END_SESSION_URL}?`
            + `id_token_hint=${encodeURIComponent(session.id_token)}&`
            + `post_logout_redirect_uri=${encodeURIComponent(process.env.NEXT_PUBLIC_NEXTAUTH_URL!)}`;

        // Redirection vers Keycloak pour déconnecter l'utilisateur côté serveur
        window.location.href = keycloakSignoutUrl;

        // Déconnexion côté client
        await signOut({ callbackUrl: '/' });
    };

    return (
        <button
            onClick={handleSignout}
            className="flex items-center w-full gap-5 self-start rounded-lg bg-red-500 px-6 py-3 text-sm font-medium text-white transition-colors hover:bg-red-400 md:text-base">
            <PowerIcon className="w-5 md:w-6" /><span>Logout</span>
        </button>
    );
}