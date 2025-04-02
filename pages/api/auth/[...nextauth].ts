import NextAuth from "next-auth";
import KeycloakProvider from "next-auth/providers/keycloak";

export default NextAuth({
    providers: [
        KeycloakProvider({
            clientId: "nextjs-app",
            clientSecret: "ac3QVt2vUwHtpGFzYhBb31eYbVn6Cz4H", // Replace with your Keycloak client secret
            issuer: "http://localhost:8080/realms/nextjs-dashboard",
        }),
    ],
});