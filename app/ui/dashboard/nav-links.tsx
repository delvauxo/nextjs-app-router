'use client';

import {
  UserGroupIcon,
  HomeIcon,
  DocumentDuplicateIcon,
} from '@heroicons/react/24/outline';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import clsx from 'clsx';
import { useSession } from 'next-auth/react';
import { getRolesFromToken } from '@/app/lib/utils';

// Map des liens qui sont dans le menu
const links = [
  {
    name: 'Home',
    href: '/dashboard', // Cette valeur sera modifiée dynamiquement en fonction du rôle
    icon: HomeIcon,
  },
  {
    name: 'Invoices',
    href: '/dashboard/invoices', // Idem
    icon: DocumentDuplicateIcon,
  },
  {
    name: 'Customers',
    href: '/dashboard/customers', // Idem
    icon: UserGroupIcon,
  },
];

export default function NavLinks() {
  const pathname = usePathname();
  const { data: session } = useSession();

  // Vérifier le rôle de l'utilisateur et déterminer le préfixe approprié
  const rolePrefix = session?.id_token ? getRolesFromToken(session.id_token).find(role => role.startsWith('dashboard_')) : '';
  const dashboardPrefix = rolePrefix ? rolePrefix.split('_')[1] : 'guest'; // 'owner' ou 'renter', ou 'guest' si aucun rôle n'est trouvé

  return (
    <>
      {links.map((link) => {
        const LinkIcon = link.icon;

        // Modifier le href pour inclure dynamiquement le préfixe du rôle
        const dynamicHref = `/${dashboardPrefix}${link.href}`; // Dynamique selon le rôle

        return (
          <Link
            key={link.name}
            href={dynamicHref}
            className={clsx(
              'flex h-[48px] grow items-center justify-center gap-2 rounded-md bg-gray-50 p-3 text-sm font-medium hover:bg-sky-100 hover:text-blue-600 md:flex-none md:justify-start md:p-2 md:px-3',
              {
                'bg-sky-100 text-blue-600': pathname === dynamicHref,
              },
            )}
          >
            <LinkIcon className="w-6" />
            <p className="hidden md:block">{link.name}</p>
          </Link>
        );
      })}
    </>
  );
}
