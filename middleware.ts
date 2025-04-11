import { NextResponse } from 'next/server';
import { NextRequest } from 'next/server';
import { checkRole } from '@/app/lib/utils';  // Importer la fonction utilitaire

export async function middleware(request: NextRequest) {
    const pathname = request.nextUrl.pathname;

    // Vérifier les rôles pour le dashboard "owner"
    if (pathname.startsWith('/owner')) {
        const response = await checkRole(request, 'dashboard_owner', '/owner');
        if (response) return response;
    }

    // Vérifier les rôles pour le dashboard "renter"
    if (pathname.startsWith('/renter')) {
        const response = await checkRole(request, 'dashboard_renter', '/renter');
        if (response) return response;
    }

    return NextResponse.next();
}

export const config = {
    matcher: [
        '/owner/:path*',
        '/renter/:path*',
    ],
};
