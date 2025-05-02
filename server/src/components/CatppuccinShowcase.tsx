"use client";

import React from 'react';
import { motion } from 'framer-motion';
import { useTheme } from '@/context/ThemeContext';

const CatppuccinShowcase: React.FC = () => {
  const { currentTheme } = useTheme();

  return (
    <motion.div
      className="w-full rounded-lg overflow-hidden shadow-lg p-6 mb-8"
      style={{
        backgroundColor: `color-mix(in srgb, ${currentTheme.colors.base} 50%, transparent)`,
        backdropFilter: 'blur(8px)',
        borderColor: currentTheme.colors.surface0,
        borderWidth: '1px',
        borderStyle: 'solid'
      }}
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5, delay: 0.2 }}
    >
      <h3 className="text-2xl font-semibold mb-4" style={{ color: currentTheme.colors.text }}>
        🎨 Catppuccin Tailwind CSS
      </h3>
      <p className="mb-6" style={{ color: currentTheme.colors.subtext0 }}>
        Explore the beautiful Catppuccin color palette integrated with Tailwind CSS
      </p>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Color Palette */}
        <div className="space-y-4">
          <h4 className="text-xl font-medium" style={{ color: currentTheme.colors.text }}>
            {currentTheme.label} Palette
          </h4>
          <div className="grid grid-cols-4 gap-2">
            <div className="flex flex-col items-center">
              <div className="w-12 h-12 rounded-lg" style={{ backgroundColor: currentTheme.colors.rosewater }}></div>
              <span className="text-xs mt-1" style={{ color: currentTheme.colors.subtext0 }}>Rosewater</span>
            </div>
            <div className="flex flex-col items-center">
              <div className="w-12 h-12 rounded-lg" style={{ backgroundColor: currentTheme.colors.flamingo }}></div>
              <span className="text-xs mt-1" style={{ color: currentTheme.colors.subtext0 }}>Flamingo</span>
            </div>
            <div className="flex flex-col items-center">
              <div className="w-12 h-12 rounded-lg" style={{ backgroundColor: currentTheme.colors.pink }}></div>
              <span className="text-xs mt-1" style={{ color: currentTheme.colors.subtext0 }}>Pink</span>
            </div>
            <div className="flex flex-col items-center">
              <div className="w-12 h-12 rounded-lg" style={{ backgroundColor: currentTheme.colors.mauve }}></div>
              <span className="text-xs mt-1" style={{ color: currentTheme.colors.subtext0 }}>Mauve</span>
            </div>
            <div className="flex flex-col items-center">
              <div className="w-12 h-12 rounded-lg" style={{ backgroundColor: currentTheme.colors.red }}></div>
              <span className="text-xs mt-1" style={{ color: currentTheme.colors.subtext0 }}>Red</span>
            </div>
            <div className="flex flex-col items-center">
              <div className="w-12 h-12 rounded-lg" style={{ backgroundColor: currentTheme.colors.maroon }}></div>
              <span className="text-xs mt-1" style={{ color: currentTheme.colors.subtext0 }}>Maroon</span>
            </div>
            <div className="flex flex-col items-center">
              <div className="w-12 h-12 rounded-lg" style={{ backgroundColor: currentTheme.colors.peach }}></div>
              <span className="text-xs mt-1" style={{ color: currentTheme.colors.subtext0 }}>Peach</span>
            </div>
            <div className="flex flex-col items-center">
              <div className="w-12 h-12 rounded-lg" style={{ backgroundColor: currentTheme.colors.yellow }}></div>
              <span className="text-xs mt-1" style={{ color: currentTheme.colors.subtext0 }}>Yellow</span>
            </div>
            <div className="flex flex-col items-center">
              <div className="w-12 h-12 rounded-lg" style={{ backgroundColor: currentTheme.colors.green }}></div>
              <span className="text-xs mt-1" style={{ color: currentTheme.colors.subtext0 }}>Green</span>
            </div>
            <div className="flex flex-col items-center">
              <div className="w-12 h-12 rounded-lg" style={{ backgroundColor: currentTheme.colors.teal }}></div>
              <span className="text-xs mt-1" style={{ color: currentTheme.colors.subtext0 }}>Teal</span>
            </div>
            <div className="flex flex-col items-center">
              <div className="w-12 h-12 rounded-lg" style={{ backgroundColor: currentTheme.colors.sky }}></div>
              <span className="text-xs mt-1" style={{ color: currentTheme.colors.subtext0 }}>Sky</span>
            </div>
            <div className="flex flex-col items-center">
              <div className="w-12 h-12 rounded-lg" style={{ backgroundColor: currentTheme.colors.sapphire }}></div>
              <span className="text-xs mt-1" style={{ color: currentTheme.colors.subtext0 }}>Sapphire</span>
            </div>
          </div>
        </div>

        {/* Tailwind Integration */}
        <div className="space-y-4">
          <h4 className="text-xl font-medium" style={{ color: currentTheme.colors.text }}>Tailwind Integration</h4>
          <div className="space-y-4">
            <div className="p-4 rounded-lg" style={{ backgroundColor: currentTheme.colors.base, color: currentTheme.colors.text }}>
              <p className="font-mono text-sm">bg-ctp-{currentTheme.name}-base text-ctp-{currentTheme.name}-text</p>
            </div>
            <div className="p-4 rounded-lg" style={{ backgroundColor: currentTheme.colors.surface0, color: currentTheme.colors.text }}>
              <p className="font-mono text-sm">bg-ctp-{currentTheme.name}-surface0 text-ctp-{currentTheme.name}-text</p>
            </div>
            <div className="p-4 rounded-lg" style={{ backgroundColor: currentTheme.colors.mauve, color: currentTheme.colors.base }}>
              <p className="font-mono text-sm">bg-ctp-{currentTheme.name}-mauve text-ctp-{currentTheme.name}-base</p>
            </div>
            <div className="p-4 rounded-lg" style={{ backgroundColor: currentTheme.colors.red, color: currentTheme.colors.base }}>
              <p className="font-mono text-sm">bg-ctp-{currentTheme.name}-red text-ctp-{currentTheme.name}-base</p>
            </div>
          </div>
        </div>
      </div>

      <div className="mt-8 p-4 rounded-lg" style={{ backgroundColor: currentTheme.colors.base, color: currentTheme.colors.text }}>
        <div className="font-mono text-sm">
          <div className="mb-2">{/* Example Tailwind CSS usage with Catppuccin */}</div>
          <div>&lt;div className=&quot;
            <span style={{ color: currentTheme.colors.green }}>bg-ctp-{currentTheme.name}-base</span>
            <span style={{ color: currentTheme.colors.sky }}> text-ctp-{currentTheme.name}-text</span>
            <span style={{ color: currentTheme.colors.yellow }}> p-4</span>
            <span style={{ color: currentTheme.colors.pink }}> rounded-lg</span>&quot;&gt;
          </div>
          <div>&nbsp;&nbsp;Your content here</div>
          <div>&lt;/div&gt;</div>
        </div>
      </div>
    </motion.div>
  );
};

export default CatppuccinShowcase;
