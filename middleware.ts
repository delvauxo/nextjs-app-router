import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';
import { getToken } from 'next-auth/jwt';
import { getRolesFromToken } from '@/app/lib/utils';

// Middleware exécuté pour chaque requête sur /owner/* et /renter/*
export async function middleware(request: NextRequest) {
    const token = await getToken({ req: request });

    // Redirige vers l'authentification si l'utilisateur n'est pas authentifié
    if (!token) {
        return NextResponse.redirect(new URL('/api/auth/signin', request.url));
    }

    const roles = getRolesFromToken(token.id_token!) || [];
    const pathname = request.nextUrl.pathname;

    // Accès à /owner, mais sans rôle adéquat
    if (pathname.startsWith('/owner') && !roles.includes('dashboard_owner')) {
        return NextResponse.redirect(new URL('/unauthorized', request.url));
    }

    // Accès à /renter, mais sans rôle adéquat
    if (pathname.startsWith('/renter') && !roles.includes('dashboard_renter')) {
        return NextResponse.redirect(new URL('/unauthorized', request.url));
    }

    return NextResponse.next();
}

// Routes sur lesquelles le middleware s'applique
export const config = {
    matcher: [
        '/owner/:path*',
        '/renter/:path*',
    ],
};
