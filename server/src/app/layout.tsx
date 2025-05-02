import type { Metadata } from 'next'
import { Inter, Space_Mono } from 'next/font/google'
import '../styles/globals.css'
import { ThemeProvider } from '@/context/ThemeContext'
import GlobalThemeSwitcher from '@/components/GlobalThemeSwitcher'

const inter = Inter({
  subsets: ['latin'],
  variable: '--font-inter',
  display: 'swap',
})

const spaceMono = Space_Mono({
  weight: ['400', '700'],
  subsets: ['latin'],
  variable: '--font-space-mono',
  display: 'swap',
})

export const metadata: Metadata = {
  title: 'Dotfiles Showcase',
  description: 'A cosmic journey through my development environment',
  keywords: ['dotfiles', 'neovim', 'tmux', 'nushell', 'chezmoi', 'catppuccin', 'development environment'],
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" className={`${inter.variable} ${spaceMono.variable}`}>
      <head>
        <link rel="icon" href="/favicon.ico" sizes="any" />
      </head>
      <body className={`${inter.className} antialiased`}>
        <ThemeProvider>
          <GlobalThemeSwitcher />
          {children}
        </ThemeProvider>
      </body>
    </html>
  )
}
