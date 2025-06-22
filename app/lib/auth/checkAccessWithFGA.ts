import { getToken } from 'next-auth/jwt';
import { NextResponse, NextRequest } from 'next/server';

const STORE_ID = process.env.FGA_STORE_ID!;
const FGA_API_URL = `${process.env.FGA_API_URL}/stores/${STORE_ID}/check`;

export async function checkAccessWithFGA(
    request: NextRequest,
    dashboardType: 'admin' | 'owner' | 'renter',
    pathPrefix: string
) {
    const token = await getToken({ req: request });

    if (!token || !token.id_token) {
        return NextResponse.redirect(new URL('/api/auth/signin', request.url));
    }

    const userId = JSON.parse(atob(token.id_token.split('.')[1])).sub;
    const pathname = request.nextUrl.pathname;

    if (!userId) {
        return NextResponse.redirect(new URL('/unauthorized', request.url));
    }

    if (!pathname.startsWith(pathPrefix)) {
        return NextResponse.next();
    }

    const body = {
        store_id: STORE_ID,
        tuple_key: {
            user: `user:${userId}`,
            relation: dashboardType,
            object: `dashboard:${dashboardType}`,
        },
    };

    const fgaResponse = await fetch(FGA_API_URL, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(body),
    });

    const result = await fgaResponse.json();

    if (!result.allowed) {
        return NextResponse.redirect(new URL('/unauthorized', request.url));
    }

    return NextResponse.next();
}