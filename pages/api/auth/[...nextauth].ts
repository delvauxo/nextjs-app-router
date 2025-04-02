import NextAuth from "next-auth";
import KeycloakProvider from "next-auth/providers/keycloak";

export default NextAuth({
    providers: [
        KeycloakProvider({
            clientId: "nextjs-app",
            clientSecret: "e20Y5FZIZ9Gq5XEf5oiYzz3BBTvoMXCN", // Replace with your Keycloak client secret
            issuer: "http://localhost:8080/realms/nextjs-dashboard",
        }),
    ],
});