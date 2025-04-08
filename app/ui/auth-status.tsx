"use client";

import { useSession } from 'next-auth/react';
import Link from 'next/link';
import { ArrowRightIcon } from '@heroicons/react/20/solid';
export default function AuthStatus() {

    // Utilise useSession pour récupérer l'état de la session
    const { data: session, status } = useSession();

    // Vérifie l'état de la session
    if (status === "loading") {
        // Affiche un message de chargement pendant que la session est en cours de récupération
        return <div>Chargement...</div>;
    }

    // Si la session est absente, l'utilisateur n'est pas connecté
    if (!session) {
        return (
            <div className="flex flex-col justify-center gap-2 rounded-lg bg-gray-50 px-6">
                <span className="mr-4">Vous n'êtes pas connecté.</span>
                <Link
                    href="/api/auth/signin"
                    className="flex items-center w-full gap-5 self-start rounded-lg bg-blue-500 px-6 py-3 text-sm font-medium text-white transition-colors hover:bg-blue-400 md:text-base"
                >
                    <span className='w-full'>Log in</span> <ArrowRightIcon className="w-5 md:w-6" />
                </Link>
            </div>
        );
    }

    // Si l'utilisateur est connecté, on affiche ses informations
    return (
        <div className="flex flex-col justify-center gap-2 rounded-lg bg-gray-50 px-6">
            <h1 className="mr-4">Bienvenue, {session.user?.name || "utilisateur"}</h1>
            <p>Email: {session.user?.email}</p>
            <Link
                href="/api/auth/signout"
                className="flex items-center w-full gap-5 self-start rounded-lg bg-blue-500 px-6 py-3 text-sm font-medium text-white transition-colors hover:bg-blue-400 md:text-base"
            >
                <span className='w-full'>Log out</span> <ArrowRightIcon className="w-5 md:w-6" />
            </Link>
        </div>
    );
}