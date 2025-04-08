"use client";

import { useSession } from 'next-auth/react';
import { getRolesFromToken } from 'app/lib/utils';
import LogoutButton from './LogoutButton';
import LoginButton from './LoginButton';
import { ChartBarIcon } from '@heroicons/react/24/solid';
import Link from 'next/link';

export default function AuthStatus() {
    // Utilise useSession pour récupérer l'état de la session
    const { data: session, status } = useSession();

    // Vérifie l'état de la session et affiche un message de chargement pendant que la session est en cours de récupération
    if (status === "loading") {
        return <div>Chargement...</div>;
    }

    // Si la session est absente, l'utilisateur n'est pas connecté
    if (!session) {
        return (
            <div className="flex flex-col justify-center gap-2 rounded-lg bg-gray-50 px-6">
                <span className="mr-4">Vous n'êtes pas connecté.</span>
                {/* Affichage du bouton de connexion */}
                <LoginButton />
            </div>
        );
    }

    // Accéder directement à l'ID Token de la session
    const idToken = session.id_token;
    const roles = idToken ? getRolesFromToken(idToken) : [];
    const firstRole = roles.length > 0 ? roles[0] : 'Aucun rôle attribué';

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
            {roles.length > 0 ? (
                <Link
                    href={`/${firstRole}/dashboard`}
                    className='flex h-[48px] w-full grow items-center justify-center gap-2 rounded-md bg-blue-500 p-3 text-sm font-medium hover:bg-blue-400 text-white md:flex-none md:justify-start md:p-2 md:px-3'
                >
                    <ChartBarIcon className="w-6" />
                    <div className="hidden md:block">Dashboard</div>
                </Link>
            ) : (
                <p>Aucun rôle attribué, accès limité au dashboard.</p>
            )}

            {/* Affichage du bouton de déconnexion */}
            <LogoutButton />
        </div>
    );
}
