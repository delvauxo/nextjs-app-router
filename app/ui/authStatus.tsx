'use client';

import { useSession } from "next-auth/react";
import ButtonSignin from "./buttonSignin";
import ButtonSignout from "./buttonSingout";
import { getRolesFromToken } from '@/app/lib/utils';
import { ChartBarIcon } from '@heroicons/react/24/solid';
import Link from 'next/link';

export default function AuthStatus() {

    const { data: session, status } = useSession();

    if (status === 'loading') {
        return <p>Loading...</p>;
    }

    if (!session) {
        return (
            <div className="flex flex-col justify-center gap-2 rounded-lg bg-gray-50 px-6">
                <span className="mr-4">Vous n'êtes pas connecté.</span>
                <ButtonSignin />
            </div>
        );
    }

    // Accéder directement à l'ID Token de la session
    const idToken = session.id_token;
    const role = idToken ? getRolesFromToken(idToken) : [];
    const firstRole = role.find(role => role.startsWith('dashboard_')) || ''; // Changed ':' to '||'
    const dashboardPrefix = firstRole ? firstRole.split('_')[1] : 'guest'; // 'owner' ou 'renter', ou 'guest' si aucun rôle n'est trouvé

    // Si l'utilisateur est connecté, on affiche ses informations
    return (
        <div className="flex flex-col justify-center gap-2 rounded-lg bg-gray-50 px-6">
            <h1 className="mr-4">Bienvenue, {session.user?.name || "utilisateur"}</h1>
            <p>Email: {session.user?.email}</p>

            {/* Affichage de l'ID Token si disponible */}
            {session.id_token && (
                <p className="text-sm text-gray-500 break-all">
                    <strong>ID Token:</strong> {session.id_token}
                </p>
            )}

            {/* Link - Dashboard, avec un lien dynamique basé sur le premier rôle */}
            {role.length > 0 ? (
                <Link
                    href={`/${dashboardPrefix}/dashboard`}
                    className='flex items-center w-full gap-5 self-start rounded-lg bg-blue-500 px-6 py-3 text-sm font-medium text-white transition-colors hover:bg-blue-400 md:text-base'
                >
                    <ChartBarIcon className="w-5 md:w-6" /><span>Dashboard</span>
                </Link>
            ) : (
                <p>Aucun rôle attribué, accès limité au dashboard.</p>
            )}

            {/* Affichage du bouton de déconnexion */}
            <ButtonSignout />
        </div>
    );
}