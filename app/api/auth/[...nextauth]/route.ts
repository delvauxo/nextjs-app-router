import NextAuth from "next-auth";
import Keycloak from "next-auth/providers/keycloak";

const handler = NextAuth({
    providers: [
        Keycloak({
            clientId: process.env.KEYCLOAK_CLIENT_ID!,
            clientSecret: process.env.KEYCLOAK_CLIENT_SECRET!,
            issuer: process.env.KEYCLOAK_ISSUER
        })
    ],
    callbacks: {
        // Ajoute l'id_token au JWT pour le rendre disponible
        async jwt({ token, account }) {
            if (account?.id_token) token.id_token = account.id_token;
            return token;
        },

        // Ajoute l'id_token à la session pour qu'il soit accessible côté client
        async session({ session, token }) {
            session.id_token = token.id_token as string;
            return session;
        }
    },
    // Secret pour la gestion de la session
    secret: process.env.NEXTAUTH_SECRET,
    // debug: true
});

export { handler as GET, handler as POST };