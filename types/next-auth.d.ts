import NextAuth, { DefaultSession, DefaultUser } from "next-auth";

declare module "next-auth" {
    interface Session {
        id_token?: string;
        user?: DefaultSession["user"];
    }

    interface User extends DefaultUser {
        id?: string;
    }
}

declare module "next-auth/jwt" {
    interface JWT {
        id_token?: string;
    }
}