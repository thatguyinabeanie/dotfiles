"use client";

import { motion } from 'framer-motion';
import DotfilesShowcase from '@/components/DotfilesShowcase';
import AsciiBanner from '@/components/AsciiBanner';
import ParticleBackground from '@/components/ParticleBackground';
import CatppuccinShowcase from '@/components/CatppuccinShowcase';
import { useTheme } from '@/context/ThemeContext';

export default function Home() {
  const { currentTheme } = useTheme();

  return (
    <main className="flex min-h-screen flex-col items-center p-8 md:p-24 relative overflow-hidden">
      {/* Animated background */}
      <ParticleBackground />

      <motion.div
        className="z-10 max-w-6xl w-full items-center"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ duration: 0.8 }}
        style={{ color: currentTheme.colors.text }}
      >
        <div className="text-center mb-8">
          {/* ASCII Art Banner */}
          <AsciiBanner />

          <motion.h1
            className="text-5xl font-bold mb-4 text-transparent bg-clip-text bg-gradient-to-r from-blue-400 via-purple-500 to-pink-500"
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, delay: 0.3 }}
          >
            Dotfiles Showcase
          </motion.h1>

          <motion.p
            className="text-xl text-gray-300 max-w-3xl mx-auto"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.5, delay: 0.5 }}
          >
            A cosmic journey through my development environment
          </motion.p>
        </div>

        <motion.div
          className="bg-gray-800/30 backdrop-blur-sm rounded-lg p-8 mb-12 border border-gray-700 shadow-xl"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.2 }}
        >
          <motion.h2
            className="text-3xl font-semibold mb-6"
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.5, delay: 0.3 }}
          >
            <span className="text-purple-400">✨</span> Cosmic Development Environment
          </motion.h2>

          <motion.p
            className="text-lg mb-6"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.5, delay: 0.4 }}
          >
            A modern and efficient development environment setup that's out of this world!
            Managed with Chezmoi for seamless configuration across machines.
          </motion.p>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mt-8">
            <motion.div
              className="border border-gray-700 rounded-lg p-6 bg-gray-800/50 hover:border-purple-500 transition-all duration-300"
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ duration: 0.5, delay: 0.5 }}
              whileHover={{ scale: 1.02 }}
            >
              <h3 className="text-2xl font-medium mb-4 text-purple-400">🛠️ Tools</h3>
              <ul className="space-y-2">
                <li className="flex items-center">
                  <span className="text-green-400 mr-2">→</span> Neovim for editing
                </li>
                <li className="flex items-center">
                  <span className="text-green-400 mr-2">→</span> Tmux for terminal multiplexing
                </li>
                <li className="flex items-center">
                  <span className="text-green-400 mr-2">→</span> Nushell for modern shell
                </li>
                <li className="flex items-center">
                  <span className="text-green-400 mr-2">→</span> K9s for Kubernetes management
                </li>
                <li className="flex items-center">
                  <span className="text-green-400 mr-2">→</span> Yazi for file management
                </li>
              </ul>
            </motion.div>

            <motion.div
              className="border border-gray-700 rounded-lg p-6 bg-gray-800/50 hover:border-pink-500 transition-all duration-300"
              initial={{ opacity: 0, x: 20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ duration: 0.5, delay: 0.6 }}
              whileHover={{ scale: 1.02 }}
            >
              <h3 className="text-2xl font-medium mb-4 text-pink-400">🎨 Themes</h3>
              <p className="mb-4">
                Featuring the beautiful Catppuccin theme across all applications
                for a consistent and pleasing visual experience.
              </p>
              <div className="flex space-x-2 mt-4">
                <motion.div
                  className="w-8 h-8 rounded-full bg-[#f5c2e7]"
                  title="Pink"
                  whileHover={{ scale: 1.2 }}
                  transition={{ duration: 0.2 }}
                ></motion.div>
                <motion.div
                  className="w-8 h-8 rounded-full bg-[#cba6f7]"
                  title="Mauve"
                  whileHover={{ scale: 1.2 }}
                  transition={{ duration: 0.2 }}
                ></motion.div>
                <motion.div
                  className="w-8 h-8 rounded-full bg-[#f38ba8]"
                  title="Red"
                  whileHover={{ scale: 1.2 }}
                  transition={{ duration: 0.2 }}
                ></motion.div>
                <motion.div
                  className="w-8 h-8 rounded-full bg-[#fab387]"
                  title="Peach"
                  whileHover={{ scale: 1.2 }}
                  transition={{ duration: 0.2 }}
                ></motion.div>
                <motion.div
                  className="w-8 h-8 rounded-full bg-[#a6e3a1]"
                  title="Green"
                  whileHover={{ scale: 1.2 }}
                  transition={{ duration: 0.2 }}
                ></motion.div>
                <motion.div
                  className="w-8 h-8 rounded-full bg-[#89dceb]"
                  title="Sky"
                  whileHover={{ scale: 1.2 }}
                  transition={{ duration: 0.2 }}
                ></motion.div>
              </div>
            </motion.div>
          </div>
        </motion.div>

        <DotfilesShowcase />

        <CatppuccinShowcase />

        <motion.div
          className="text-center mt-12"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.7 }}
        >
          <motion.a
            href="https://github.com/thatguyinabeanie/dotfiles"
            className="px-8 py-4 bg-gradient-to-r from-purple-600 to-blue-600 text-white rounded-lg hover:from-purple-700 hover:to-blue-700 transition-all text-lg font-medium shadow-lg hover:shadow-purple-500/20"
            target="_blank"
            rel="noopener noreferrer"
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
          >
            View on GitHub
          </motion.a>
        </motion.div>
      </motion.div>
    </main>
  )
}
