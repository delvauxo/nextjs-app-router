import { Revenue } from './definitions';
import { NextRequest, NextResponse } from 'next/server';
import { getToken } from 'next-auth/jwt';

export const formatCurrency = (amount: number) => {
  return (amount / 100).toLocaleString('fr-BE', {
    style: 'currency',
    currency: 'EUR',
  });
};

export const formatDateToLocal = (
  dateStr: string,
  locale: string = 'en-US',
) => {
  const date = new Date(dateStr);
  const options: Intl.DateTimeFormatOptions = {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
  };
  const formatter = new Intl.DateTimeFormat(locale, options);
  return formatter.format(date);
};

export const generateYAxis = (revenue: Revenue[]) => {
  // Calculate what labels we need to display on the y-axis
  // based on highest record and in 1000s
  const yAxisLabels = [];
  const highestRecord = Math.max(...revenue.map((month) => month.revenue));
  const topLabel = Math.ceil(highestRecord / 1000) * 1000;

  for (let i = topLabel; i >= 0; i -= 1000) {
    yAxisLabels.push(`$${i / 1000}K`);
  }

  return { yAxisLabels, topLabel };
};

export const generatePagination = (currentPage: number, totalPages: number) => {
  // If the total number of pages is 7 or less,
  // display all pages without any ellipsis.
  if (totalPages <= 7) {
    return Array.from({ length: totalPages }, (_, i) => i + 1);
  }

  // If the current page is among the first 3 pages,
  // show the first 3, an ellipsis, and the last 2 pages.
  if (currentPage <= 3) {
    return [1, 2, 3, '...', totalPages - 1, totalPages];
  }

  // If the current page is among the last 3 pages,
  // show the first 2, an ellipsis, and the last 3 pages.
  if (currentPage >= totalPages - 2) {
    return [1, 2, '...', totalPages - 2, totalPages - 1, totalPages];
  }

  // If the current page is somewhere in the middle,
  // show the first page, an ellipsis, the current page and its neighbors,
  // another ellipsis, and the last page.
  return [
    1,
    '...',
    currentPage - 1,
    currentPage,
    currentPage + 1,
    '...',
    totalPages,
  ];
};


// ##############################################################
// #############              PERSO.            #################
// ##############################################################


// Fonction utilitaire pour récupérer les rôles depuis l'ID Token
export const getRolesFromToken = (idToken: string): string[] => {
  try {
    const decodedToken = JSON.parse(atob(idToken.split('.')[1]));  // Décoder la payload du JWT
    return decodedToken?.roles || []; // Retourner les rôles ou une liste vide
  } catch (error) {
    console.error('Erreur de décodage du token:', error);
    return [];
  }
};

// Lire un JWT en TypeScript (sans le vérifier)
export function decodeJWT(token: string) {
  const [header, payload, signature] = token.split('.');

  const decodedHeader = JSON.parse(atob(header));
  const decodedPayload = JSON.parse(atob(payload));

  return {
    header: decodedHeader,
    payload: decodedPayload,
    signature: signature,
  };
}

// Fonction pour vérifier les rôles et rediriger si nécessaire
export async function checkRole(
  request: NextRequest,
  requiredRole: string,
  pathPrefix: string
) {
  const token = await getToken({ req: request });

  if (!token) {
    return NextResponse.redirect(new URL('/api/auth/signin', request.url));
  }

  const roles = getRolesFromToken(token.id_token!) || [];
  const pathname = request.nextUrl.pathname;

  if (pathname.startsWith(pathPrefix)) {
    if (!roles.includes(requiredRole)) {
      return NextResponse.redirect(new URL('/unauthorized', request.url));
    }
  }

  return NextResponse.next();
}