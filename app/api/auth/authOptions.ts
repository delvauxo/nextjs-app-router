import { JWT } from 'next-auth/jwt';
import Keycloak from 'next-auth/providers/keycloak';

export const authOptions = {
    providers: [
        Keycloak({
            clientId: process.env.KEYCLOAK_CLIENT_ID!,
            clientSecret: process.env.KEYCLOAK_CLIENT_SECRET!,
            issuer: process.env.KEYCLOAK_ISSUER
        })
    ],
    callbacks: {
        // Ajoute l'id_token au JWT pour le rendre disponible
        async jwt({ token, account }: { token: JWT; account?: any; }) {
            if (account?.id_token) token.id_token = account.id_token;
            return token;
        },

        // Ajoute l'id_token à la session pour le rendre disponible dans le front
        async session({ session, token }: { session: any; token: JWT; }) {
            // Si l'utilisateur est connecté, on ajoute l'id_token à la session
            session.id_token = token.id_token as string;
            return session;
        }
    },
    // Secret pour la gestion de la session
    secret: process.env.NEXTAUTH_SECRET,
    // debug: true
};