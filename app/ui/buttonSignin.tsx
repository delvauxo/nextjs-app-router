'use client';

import { ArrowRightIcon } from "@heroicons/react/24/outline";
import { signIn } from "next-auth/react";

export default function ButtonSignin() {

    const handleSignin = async () => {
        await signIn('keycloak');
    };

    return (
        <button
            onClick={handleSignin}
            className="flex items-center w-full gap-5 self-start rounded-lg bg-blue-500 px-6 py-3 text-sm font-medium text-white transition-colors hover:bg-blue-400 md:text-base">
            <span className='w-full'>Log in</span> <ArrowRightIcon className="w-5 md:w-6" />
        </button>
    );
}