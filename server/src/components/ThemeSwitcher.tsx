"use client";

import React, { useState } from 'react';
import { motion } from 'framer-motion';

interface ThemeOption {
  name: string;
  label: string;
  colors: {
    primary: string;
    secondary: string;
    accent: string;
    background: string;
    text: string;
  };
}

const ThemeSwitcher: React.FC = () => {
  const themes: ThemeOption[] = [
    {
      name: 'mocha',
      label: 'Mocha',
      colors: {
        primary: '#cba6f7',
        secondary: '#f38ba8',
        accent: '#fab387',
        background: '#1e1e2e',
        text: '#cdd6f4',
      },
    },
    {
      name: 'macchiato',
      label: 'Macchiato',
      colors: {
        primary: '#c6a0f6',
        secondary: '#ed8796',
        accent: '#f5a97f',
        background: '#24273a',
        text: '#cad3f5',
      },
    },
    {
      name: 'frappe',
      label: 'Frappé',
      colors: {
        primary: '#ca9ee6',
        secondary: '#e78284',
        accent: '#ef9f76',
        background: '#303446',
        text: '#c6d0f5',
      },
    },
    {
      name: 'latte',
      label: 'Latte',
      colors: {
        primary: '#8839ef',
        secondary: '#d20f39',
        accent: '#fe640b',
        background: '#eff1f5',
        text: '#4c4f69',
      },
    },
  ];

  const [activeTheme, setActiveTheme] = useState<string>(themes[0].name);

  return (
    <motion.div
      className="w-full rounded-lg overflow-hidden shadow-lg border border-gray-700 bg-gray-800/50 backdrop-blur-sm p-6 mb-8"
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5, delay: 0.2 }}
    >
      <h3 className="text-2xl font-semibold mb-4">🎨 Catppuccin Theme Flavors</h3>
      <p className="text-gray-300 mb-6">
        Experience the beauty of Catppuccin in four delicious flavors that transform your development environment
      </p>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        {themes.map((theme) => (
          <motion.div
            key={theme.name}
            className={`rounded-lg p-4 cursor-pointer transition-all duration-300 ${
              activeTheme === theme.name
                ? 'ring-2 ring-offset-2 ring-offset-gray-800 ring-purple-500'
                : 'hover:bg-gray-700'
            }`}
            style={{
              backgroundColor: theme.colors.background,
            }}
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            onClick={() => setActiveTheme(theme.name)}
          >
            <div className="text-center" style={{ color: theme.colors.text }}>
              <h4 className="font-medium mb-2">{theme.label}</h4>
              <div className="flex justify-center space-x-2 mb-3">
                <div
                  className="w-6 h-6 rounded-full"
                  style={{ backgroundColor: theme.colors.primary }}
                ></div>
                <div
                  className="w-6 h-6 rounded-full"
                  style={{ backgroundColor: theme.colors.secondary }}
                ></div>
                <div
                  className="w-6 h-6 rounded-full"
                  style={{ backgroundColor: theme.colors.accent }}
                ></div>
              </div>
              <div
                className="text-xs py-1 px-2 rounded"
                style={{
                  backgroundColor: theme.colors.primary,
                  color: theme.colors.background,
                }}
              >
                {theme.name}
              </div>
            </div>
          </motion.div>
        ))}
      </div>

      <div className="mt-6 p-4 rounded-lg" style={{ backgroundColor: themes.find(t => t.name === activeTheme)?.colors.background }}>
        <div className="flex items-center" style={{ color: themes.find(t => t.name === activeTheme)?.colors.text }}>
          <span className="font-mono mr-2">$</span>
          <span className="font-mono">echo "Catppuccin {activeTheme} is delicious!"</span>
        </div>
      </div>
    </motion.div>
  );
};

export default ThemeSwitcher;
