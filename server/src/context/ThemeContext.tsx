"use client";

import React, { createContext, useState, useContext, useEffect, ReactNode } from 'react';

export interface ThemeFlavor {
  name: string;
  label: string;
  colors: {
    rosewater: string;
    flamingo: string;
    pink: string;
    mauve: string;
    red: string;
    maroon: string;
    peach: string;
    yellow: string;
    green: string;
    teal: string;
    sky: string;
    sapphire: string;
    blue: string;
    lavender: string;
    base: string;
    mantle: string;
    crust: string;
    surface0: string;
    surface1: string;
    surface2: string;
    overlay0: string;
    overlay1: string;
    overlay2: string;
    subtext0: string;
    subtext1: string;
    text: string;
  };
}

export const themes: ThemeFlavor[] = [
  {
    name: 'latte',
    label: 'Latte',
    colors: {
      rosewater: '#dc8a78',
      flamingo: '#dd7878',
      pink: '#ea76cb',
      mauve: '#8839ef',
      red: '#d20f39',
      maroon: '#e64553',
      peach: '#fe640b',
      yellow: '#df8e1d',
      green: '#40a02b',
      teal: '#179299',
      sky: '#04a5e5',
      sapphire: '#209fb5',
      blue: '#1e66f5',
      lavender: '#7287fd',
      base: '#eff1f5',
      mantle: '#e6e9ef',
      crust: '#dce0e8',
      surface0: '#ccd0da',
      surface1: '#bcc0cc',
      surface2: '#acb0be',
      overlay0: '#9ca0b0',
      overlay1: '#8c8fa1',
      overlay2: '#7c7f93',
      subtext0: '#6c6f85',
      subtext1: '#5c5f77',
      text: '#4c4f69',
    },
  },
  {
    name: 'frappe',
    label: 'Frappé',
    colors: {
      rosewater: '#f2d5cf',
      flamingo: '#eebebe',
      pink: '#f4b8e4',
      mauve: '#ca9ee6',
      red: '#e78284',
      maroon: '#ea999c',
      peach: '#ef9f76',
      yellow: '#e5c890',
      green: '#a6d189',
      teal: '#81c8be',
      sky: '#99d1db',
      sapphire: '#85c1dc',
      blue: '#8caaee',
      lavender: '#babbf1',
      base: '#303446',
      mantle: '#292c3c',
      crust: '#232634',
      surface0: '#414559',
      surface1: '#51576d',
      surface2: '#626880',
      overlay0: '#737994',
      overlay1: '#838ba7',
      overlay2: '#949cbb',
      subtext0: '#a5adce',
      subtext1: '#b5bfe2',
      text: '#c6d0f5',
    },
  },
  {
    name: 'macchiato',
    label: 'Macchiato',
    colors: {
      rosewater: '#f4dbd6',
      flamingo: '#f0c6c6',
      pink: '#f5bde6',
      mauve: '#c6a0f6',
      red: '#ed8796',
      maroon: '#ee99a0',
      peach: '#f5a97f',
      yellow: '#eed49f',
      green: '#a6da95',
      teal: '#8bd5ca',
      sky: '#91d7e3',
      sapphire: '#7dc4e4',
      blue: '#8aadf4',
      lavender: '#b7bdf8',
      base: '#24273a',
      mantle: '#1e2030',
      crust: '#181926',
      surface0: '#363a4f',
      surface1: '#494d64',
      surface2: '#5b6078',
      overlay0: '#6e738d',
      overlay1: '#8087a2',
      overlay2: '#939ab7',
      subtext0: '#a5adcb',
      subtext1: '#b8c0e0',
      text: '#cad3f5',
    },
  },
  {
    name: 'mocha',
    label: 'Mocha',
    colors: {
      rosewater: '#f5e0dc',
      flamingo: '#f2cdcd',
      pink: '#f5c2e7',
      mauve: '#cba6f7',
      red: '#f38ba8',
      maroon: '#eba0ac',
      peach: '#fab387',
      yellow: '#f9e2af',
      green: '#a6e3a1',
      teal: '#94e2d5',
      sky: '#89dceb',
      sapphire: '#74c7ec',
      blue: '#89b4fa',
      lavender: '#b4befe',
      base: '#1e1e2e',
      mantle: '#181825',
      crust: '#11111b',
      surface0: '#313244',
      surface1: '#45475a',
      surface2: '#585b70',
      overlay0: '#6c7086',
      overlay1: '#7f849c',
      overlay2: '#9399b2',
      subtext0: '#a6adc8',
      subtext1: '#bac2de',
      text: '#cdd6f4',
    },
  },
];

interface ThemeContextType {
  currentTheme: ThemeFlavor;
  setTheme: (themeName: string) => void;
  themes: ThemeFlavor[];
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

export const ThemeProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [currentTheme, setCurrentTheme] = useState<ThemeFlavor>(themes[3]); // Default to mocha

  const setTheme = (themeName: string) => {
    const theme = themes.find(t => t.name === themeName);
    if (theme) {
      setCurrentTheme(theme);
      localStorage.setItem('catppuccin-theme', themeName);

      // Apply theme to document body
      document.documentElement.style.setProperty('--theme-base', theme.colors.base);
      document.documentElement.style.setProperty('--theme-mantle', theme.colors.mantle);
      document.documentElement.style.setProperty('--theme-crust', theme.colors.crust);
      document.documentElement.style.setProperty('--theme-text', theme.colors.text);
      document.documentElement.style.setProperty('--theme-surface0', theme.colors.surface0);
      document.documentElement.style.setProperty('--theme-surface1', theme.colors.surface1);
      document.documentElement.style.setProperty('--theme-surface2', theme.colors.surface2);
      document.documentElement.style.setProperty('--theme-overlay0', theme.colors.overlay0);
      document.documentElement.style.setProperty('--theme-overlay1', theme.colors.overlay1);
      document.documentElement.style.setProperty('--theme-overlay2', theme.colors.overlay2);
      document.documentElement.style.setProperty('--theme-subtext0', theme.colors.subtext0);
      document.documentElement.style.setProperty('--theme-subtext1', theme.colors.subtext1);
      document.documentElement.style.setProperty('--theme-mauve', theme.colors.mauve);
      document.documentElement.style.setProperty('--theme-red', theme.colors.red);
      document.documentElement.style.setProperty('--theme-pink', theme.colors.pink);
      document.documentElement.style.setProperty('--theme-green', theme.colors.green);
      document.documentElement.style.setProperty('--theme-blue', theme.colors.blue);
      document.documentElement.style.setProperty('--theme-yellow', theme.colors.yellow);
      document.documentElement.style.setProperty('--theme-peach', theme.colors.peach);
      document.documentElement.style.setProperty('--theme-teal', theme.colors.teal);
      document.documentElement.style.setProperty('--theme-sky', theme.colors.sky);
      document.documentElement.style.setProperty('--theme-sapphire', theme.colors.sapphire);
      document.documentElement.style.setProperty('--theme-lavender', theme.colors.lavender);
      document.documentElement.style.setProperty('--theme-rosewater', theme.colors.rosewater);
      document.documentElement.style.setProperty('--theme-flamingo', theme.colors.flamingo);
      document.documentElement.style.setProperty('--theme-maroon', theme.colors.maroon);

      // Set ring colors for Tailwind
      document.documentElement.style.setProperty('--ring-color', theme.colors.mauve);
      document.documentElement.style.setProperty('--ring-offset-color', theme.colors.crust);
    }
  };

  // Load saved theme from localStorage on initial render
  useEffect(() => {
    const savedTheme = localStorage.getItem('catppuccin-theme');
    if (savedTheme) {
      setTheme(savedTheme);
    } else {
      setTheme('mocha'); // Default theme
    }
  }, []);

  return (
    <ThemeContext.Provider value={{ currentTheme, setTheme, themes }}>
      {children}
    </ThemeContext.Provider>
  );
};

export const useTheme = (): ThemeContextType => {
  const context = useContext(ThemeContext);
  if (context === undefined) {
    throw new Error('useTheme must be used within a ThemeProvider');
  }
  return context;
};
