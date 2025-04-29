'use client';

import { useEffect } from 'react';

export default function Error({ error, reset }: {
    error: Error;
    reset: () => void;
}) {
    useEffect(() => {
        console.error(error);
    }, [error]);

    // On suppose que error.message est déjà une chaîne lisible grâce au gestionnaire global
    const displayMessage: string = error.message;

    return (
        <div className="p-4 bg-red-100 rounded">
            <h2 className="text-red-700 font-bold">Error</h2>
            <p className="text-red-600">{displayMessage}</p>
            <button
                onClick={reset}
                className="mt-2 px-4 py-2 bg-red-500 text-white rounded"
            >
                Réessayer
            </button>
        </div>
    );
}
