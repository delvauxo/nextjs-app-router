import { NextResponse } from 'next/server';
import { NextRequest } from 'next/server';
import { checkRoleOpenFGA } from '@/app/lib/auth/checkRoleWithFGA';

export async function middleware(request: NextRequest) {
    const pathname = request.nextUrl.pathname;

    // Vérifier les rôles pour le dashboard "admin"
    if (pathname.startsWith('/admin')) {
        const response = await checkRoleOpenFGA(request, 'admin', '/admin');
        if (response) return response;
    }

    // Vérifier les rôles pour le dashboard "owner"
    if (pathname.startsWith('/owner')) {
        const response = await checkRoleOpenFGA(request, 'owner', '/owner');
        if (response) return response;
    }

    // Vérifier les rôles pour le dashboard "renter"
    if (pathname.startsWith('/renter')) {
        const response = await checkRoleOpenFGA(request, 'renter', '/renter');
        if (response) return response;
    }

    return NextResponse.next();
}

export const config = {
    matcher: [
        '/admin/:path*',
        '/owner/:path*',
        '/renter/:path*',
    ],
};
