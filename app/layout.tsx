import '@/app/ui/global.css';
import { inter } from '@/app/ui/fonts';
import SessionProviderWrapper from '@/app/SessionProviderWrapper';

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className={`${inter.className} antialiased`}>
        <SessionProviderWrapper>
          {children}
        </SessionProviderWrapper>
      </body>
    </html>
  );
}