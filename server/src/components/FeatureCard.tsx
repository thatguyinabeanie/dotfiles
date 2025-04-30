"use client";

import React from 'react';
import { motion } from 'framer-motion';
import { useTheme } from '@/context/ThemeContext';

interface FeatureCardProps {
  title: string;
  description: string;
  icon: string;
  index?: number;
}

const FeatureCard: React.FC<FeatureCardProps> = ({ title, description, icon, index = 0 }) => {
  const { currentTheme } = useTheme();

  return (
    <motion.div
      className="backdrop-blur-sm rounded-lg p-6 transition-all"
      style={{
        backgroundColor: `color-mix(in srgb, ${currentTheme.colors.base} 80%, transparent)`,
        borderColor: currentTheme.colors.surface0,
        borderWidth: '1px',
        borderStyle: 'solid',
        boxShadow: '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)'
      }}
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5, delay: index * 0.1 }}
      whileHover={{
        scale: 1.03,
        transition: { duration: 0.2 },
        borderColor: currentTheme.colors.mauve
      }}
    >
      <div className="flex items-center mb-4">
        <motion.span
          className="text-3xl mr-4 p-2 rounded-lg"
          style={{
            backgroundColor: currentTheme.colors.surface0,
            color: currentTheme.colors.mauve
          }}
          whileHover={{ rotate: [0, -10, 10, -10, 0] }}
          transition={{ duration: 0.5 }}
        >
          {icon}
        </motion.span>
        <h3 className="text-xl font-medium" style={{ color: currentTheme.colors.text }}>{title}</h3>
      </div>
      <p style={{ color: currentTheme.colors.subtext0 }}>{description}</p>

      <motion.div
        style={{ color: currentTheme.colors.blue }}
        className="mt-4 text-sm font-medium cursor-pointer"
        whileHover={{ x: 5 }}
      >
        Learn more →
      </motion.div>
    </motion.div>
  );
};

export default FeatureCard;
