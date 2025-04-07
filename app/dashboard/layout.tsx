"use client";

import { useSession, signIn } from "next-auth/react";
// import { useEffect } from "react";
import SideNav from '@/app/ui/dashboard/sidenav';

export const experimental_ppr = true;

export default function Layout({ children }: { children: React.ReactNode; }) {
    // const { data: session, status } = useSession();

    // useEffect(() => {
    //     if (status === "unauthenticated") {
    //         signIn(); // Redirect to the Keycloak login page if not authenticated
    //     }
    // }, [status]);

    // if (status === "loading") {
    //     return <p>Loading...</p>; // Show a loading state while checking authentication
    // }

    // if (!session) {
    //     return null; // Prevent rendering if unauthenticated
    // }

    return (
        <div className="flex h-screen flex-col md:flex-row md:overflow-hidden">
            <div className="w-full flex-none md:w-64">
                <SideNav />
            </div>
            <div className="flex-grow p-6 md:overflow-y-auto md:p-12">{children}</div>
        </div>
    );
}