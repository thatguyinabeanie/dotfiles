"use client";

import React from 'react';
import { motion } from 'framer-motion';
import { useTheme } from '@/context/ThemeContext';

const GlobalThemeSwitcher: React.FC = () => {
  const { currentTheme, setTheme, themes } = useTheme();

  return (
    <motion.div
      className="fixed top-4 right-4 z-50 flex items-center space-x-2 p-2 rounded-full"
      style={{
        backgroundColor: `color-mix(in srgb, ${currentTheme.colors.surface0} 80%, transparent)`,
        backdropFilter: 'blur(8px)',
        border: `1px solid ${currentTheme.colors.overlay0}`
      }}
      initial={{ opacity: 0, y: -20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5 }}
    >
      {themes.map((theme) => (
        <motion.button
          key={theme.name}
          className={`w-8 h-8 rounded-full flex items-center justify-center transition-all duration-300 ${
            currentTheme.name === theme.name ? 'ring-2 ring-offset-2' : 'opacity-70 hover:opacity-100'
          }`}
          style={{
            backgroundColor: theme.colors.base,
            color: theme.colors.text,
            // CSS variables for ring colors that will be used by Tailwind
            '--ring-color': theme.colors.mauve,
            '--ring-offset-color': theme.colors.crust
          } as React.CSSProperties}
          onClick={() => setTheme(theme.name)}
          whileHover={{ scale: 1.1 }}
          whileTap={{ scale: 0.9 }}
          title={theme.label}
        >
          {currentTheme.name === theme.name && (
            <motion.span
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              className="text-xs"
            >
              ✓
            </motion.span>
          )}
        </motion.button>
      ))}
    </motion.div>
  );
};

export default GlobalThemeSwitcher;
