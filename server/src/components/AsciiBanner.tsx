"use client";

import React, { useState, useEffect } from 'react';
import Typewriter from 'typewriter-effect';
import { motion } from 'framer-motion';
import { useTheme } from '@/context/ThemeContext';

const asciiArt = `
  ██████╗   ██████╗ ████████╗ ███████╗ ██╗ ██╗      ███████╗ ███████╗
  ██╔══██╗ ██╔═══██╗╚══██╔══╝ ██╔════╝ ██║ ██║      ██╔════╝ ██╔════╝
  ██║  ██║ ██║   ██║   ██║    █████╗   ██║ ██║      █████╗   ███████╗
  ██║  ██║ ██║   ██║   ██║    ██╔══╝   ██║ ██║      ██╔══╝   ╚════██║
  ██████╔╝ ╚██████╔╝   ██║    ██║      ██║ ███████╗ ███████╗ ███████║
  ╚═════╝   ╚═════╝    ╚═╝    ╚═╝      ╚═╝ ╚══════╝ ╚══════╝ ╚══════╝
`;

const AsciiBanner: React.FC = () => {
  const { currentTheme } = useTheme();
  const [showBanner, setShowBanner] = useState(false);

  useEffect(() => {
    // Delay showing the banner for a smoother page load
    const timer = setTimeout(() => {
      setShowBanner(true);
    }, 500);
    return () => clearTimeout(timer);
  }, []);

  return (
    <motion.div
      className="w-full mb-8"
      initial={{ opacity: 0, y: -20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.8 }}
    >
      {showBanner && (
        <div className="font-mono flex flex-col items-center justify-center">
          <div className="text-xs sm:text-sm md:text-base overflow-x-auto w-full" style={{ color: currentTheme.colors.green }}>
            <pre className="font-mono whitespace-pre mx-auto inline-block">
{asciiArt}
            </pre>
          </div>
          <motion.div
            style={{ color: currentTheme.colors.green }}
            className="mt-2"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 1, duration: 1 }}
          >
            <Typewriter
              onInit={(typewriter) => {
                typewriter
                  .pauseFor(1000)
                  .typeString('A cosmic journey through my development environment')
                  .start();
              }}
              options={{
                delay: 50,
              }}
            />
          </motion.div>
        </div>
      )}
    </motion.div>
  );
};

export default AsciiBanner;
