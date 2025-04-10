import Link from 'next/link';
import { useState } from 'react';
import { useSession } from 'next-auth/react';
import {
    ChevronUpIcon,
    UserIcon,
    Cog6ToothIcon,
    CreditCardIcon,
    ChatBubbleLeftEllipsisIcon
} from '@heroicons/react/24/solid';

export default function UserMenu() {
    const { data: session } = useSession();
    const [open, setOpen] = useState(false);

    return (
        // Dropdown vers le haut
        <div className="relative">
            <button
                onClick={() => setOpen(!open)}
                className="flex w-full items-center justify-between rounded-md bg-gray-200 px-4 py-3 text-sm font-medium text-gray-700 hover:bg-gray-300"
            >
                <UserIcon className="w-6" />
                <div className="hidden md:block">{session!.user?.name}</div>
                <p></p>
                <ChevronUpIcon className={`w-5 h-5 transition-transform ${open ? 'rotate-180' : ''}`} />
            </button>

            {open && (
                <div className="absolute bottom-12 left-0 z-10 w-full rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5">
                    <ul className="py-1 text-sm text-gray-700">
                        <li>
                            <Link
                                href="/user/settings"
                                className="flex items-center gap-2 px-4 py-2 hover:bg-gray-100"
                            >
                                <Cog6ToothIcon className="w-5 h-5 text-gray-500" />
                                <span>Settings</span>
                            </Link>
                        </li>
                        <li>
                            <Link
                                href="/user/billings"
                                className="flex items-center gap-2 px-4 py-2 hover:bg-gray-100"
                            >
                                <CreditCardIcon className="w-5 h-5 text-gray-500" />
                                <span>Billings</span>
                            </Link>
                        </li>
                        <li>
                            <Link
                                href="/user/support"
                                className="flex items-center gap-2 px-4 py-2 hover:bg-gray-100"
                            >
                                <ChatBubbleLeftEllipsisIcon className="w-5 h-5 text-gray-500" />
                                <span>Support</span>
                            </Link>
                        </li>
                    </ul>
                </div>
            )}
        </div>
    );
}