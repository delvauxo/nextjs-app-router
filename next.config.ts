import type { NextConfig } from 'next';
import fs from 'fs';
import path from 'path';

function loadFgaStoreId(): string {
    try {
        const filePath = path.resolve(__dirname, 'fga/store.json');
        const content = fs.readFileSync(filePath, 'utf-8');
        const json = JSON.parse(content);
        return json.FGA_STORE_ID || '';
    } catch (err) {
        console.warn('Impossible de lire fga/store.json:', (err as Error).message);
        return '';
    }
}

const FGA_STORE_ID = loadFgaStoreId();

const nextConfig: NextConfig = {
    env: {
        FGA_STORE_ID, // accessible via process.env.FGA_STORE_ID
    },
};

export default nextConfig;
