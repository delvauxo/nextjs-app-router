'use client';

import { useRouter, useSearchParams } from 'next/navigation';
import { DEFAULT_CUSTOMERS_LIMIT } from '@/app/lib/config';

export default function LimitFilter() {
    const router = useRouter();
    const searchParams = useSearchParams();
    const currentLimit = Number(searchParams.get('limit')) || DEFAULT_CUSTOMERS_LIMIT;

    const handleChange = (event: React.ChangeEvent<HTMLSelectElement>) => {
        const newLimit = event.target.value;
        const params = new URLSearchParams(searchParams);
        params.set('limit', newLimit); // Met à jour la valeur de 'limit'
        router.push(`?${params.toString()}`); // Redirige avec les nouveaux paramètres
    };

    return (
        <div className="flex items-center gap-2">
            <label htmlFor="limit" className="text-sm font-medium">
                Résultats par page :
            </label>
            <select
                id="limit"
                value={currentLimit}
                onChange={handleChange}
                className="border rounded-md px-2 py-1 text-sm"
            >
                <option value="4">4</option>
                <option value="8">8</option>
                <option value="12">12</option>
                <option value="16">16</option>
                <option value="20">20</option>
            </select>
        </div>
    );
}
