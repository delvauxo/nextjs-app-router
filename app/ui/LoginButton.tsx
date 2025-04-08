import { signIn } from "next-auth/react";
import { ArrowRightIcon } from '@heroicons/react/20/solid';

export default function LoginButton() {
    return (
        <button
            className="flex items-center w-full gap-5 self-start rounded-lg bg-blue-500 px-6 py-3 text-sm font-medium text-white transition-colors hover:bg-blue-400 md:text-base"
            onClick={() => signIn('keycloak')}
        >
            <span className='w-full'>Log in</span> <ArrowRightIcon className="w-5 md:w-6" />
        </button>
    );
}