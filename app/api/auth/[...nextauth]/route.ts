import NextAuth from "next-auth";
import KeycloakProvider from "next-auth/providers/keycloak";

const handler = NextAuth({
  providers: [
    KeycloakProvider({
      clientId: process.env.KEYCLOAK_CLIENT_ID!,
      clientSecret: process.env.KEYCLOAK_CLIENT_SECRET!,
      issuer: process.env.KEYCLOAK_ISSUER,
    })
  ],
  callbacks: {
    async jwt({ token, account }) {
      if (account?.id_token) {
        token.id_token = account.id_token;
      }
      return token;
    },
    async session({ session, token }) {
      session.id_token = token.id_token as string;
      return session;
    },
    async redirect({ url, baseUrl }) {
      // Si l'URL de redirection est incorrecte, on redirige vers la page d'accueil
      if (url === 'undefined' || !url) {
        return baseUrl; // Rediriger vers la page d'accueil si nécessaire
      }
      return url; // Utilise l'URL fournie
    }
  },
  secret: process.env.NEXTAUTH_SECRET,
});

export { handler as GET, handler as POST };
