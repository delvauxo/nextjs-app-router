import { NextRequest, NextResponse } from 'next/server';
import { checkAccessWithFGA } from '@/app/lib/auth/checkAccessWithFGA';

export async function middleware(request: NextRequest) {
    const pathname = request.nextUrl.pathname;

    if (pathname.startsWith('/admin')) {
        return await checkAccessWithFGA(request, 'admin', '/admin');
    }

    if (pathname.startsWith('/owner')) {
        return await checkAccessWithFGA(request, 'owner', '/owner');
    }

    if (pathname.startsWith('/renter')) {
        return await checkAccessWithFGA(request, 'renter', '/renter');
    }

    return NextResponse.next();
}

export const config = {
    matcher: ['/admin/:path*', '/owner/:path*', '/renter/:path*'],
};

