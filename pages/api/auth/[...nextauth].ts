import NextAuth from "next-auth";
import KeycloakProvider from "next-auth/providers/keycloak";

export default NextAuth({
    providers: [
        KeycloakProvider({
            clientId: process.env.KEYCLOAK_CLIENT_ID!,
            clientSecret: process.env.KEYCLOAK_CLIENT_SECRET!,
            issuer: process.env.KEYCLOAK_ISSUER!,
            authorization: {
                params: {
                    prompt: "login", // Force l'affichage du formulaire de connexion
                },
            },
        }),
    ],
    events: {
        async signOut(message) {
            const logoutUrl = `${process.env.KEYCLOAK_ISSUER}/protocol/openid-connect/logout`;
            const params = new URLSearchParams({
                id_token_hint: message.token?.idToken as string,
                post_logout_redirect_uri: `${process.env.NEXTAUTH_URL}?prompt=login`, // Ajout de prompt=login
            });

            if (process.env.NEXTAUTH_URL) {
                params.append("post_logout_redirect_uri", process.env.NEXTAUTH_URL);
            }

            await fetch(`${logoutUrl}?${params.toString()}`, {
                method: "POST",
            });
        },
    },
    secret: process.env.NEXTAUTH_SECRET,
});