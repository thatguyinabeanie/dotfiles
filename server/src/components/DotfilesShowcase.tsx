"use client";

import React from 'react';
import { motion } from 'framer-motion';
import FeatureCard from './FeatureCard';
import TerminalWindow from './TerminalWindow';
import { useTheme } from '@/context/ThemeContext';

const DotfilesShowcase: React.FC = () => {
  const { currentTheme } = useTheme();
  const features = [
    {
      title: 'Neovim',
      description: 'Modern text editor with powerful plugins and customizations',
      icon: '🚀'
    },
    {
      title: 'Tmux',
      description: 'Terminal multiplexer for enhanced productivity',
      icon: '🖥️'
    },
    {
      title: 'Nushell',
      description: 'Modern shell with data processing capabilities',
      icon: '🐚'
    },
    {
      title: 'K9s',
      description: 'Kubernetes CLI to manage your clusters in style',
      icon: '🚢'
    },
    {
      title: 'Yazi',
      description: 'Terminal file manager with image previews',
      icon: '📁'
    },
    {
      title: 'Chezmoi',
      description: 'Dotfiles manager for seamless configuration across machines',
      icon: '🏠'
    }
  ];

  const zshrcSnippet = `# Starship prompt
eval "$(starship init zsh)"

# Mise version manager
eval "$(mise activate zsh)"

# Zoxide smart directory jumper
eval "$(zoxide init zsh)"

# Aliases
alias vim="nvim"
alias ls="eza --icons --grid --classify"
alias cat="bat --style=auto"`;

  return (
    <div className="py-12">
      <motion.h2
        className="text-4xl font-bold text-center mb-8"
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
      >
        <span className="text-transparent bg-clip-text bg-gradient-to-r from-purple-400 to-pink-600">
          Cosmic Features
        </span>
      </motion.h2>

      <TerminalWindow
        title="~/.zshrc"
        commands={[
          "cat ~/.zshrc",
          "fastfetch"
        ]}
        codeSnippet={{
          code: zshrcSnippet,
          language: "bash",
          filename: "~/.zshrc"
        }}
      />

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {features.map((feature, index) => (
          <FeatureCard
            key={index}
            title={feature.title}
            description={feature.description}
            icon={feature.icon}
            index={index}
          />
        ))}
      </div>

      <motion.div
        className="mt-16 p-6 rounded-lg"
        style={{
          backgroundColor: `color-mix(in srgb, ${currentTheme.colors.base} 50%, transparent)`,
          backdropFilter: 'blur(8px)',
          borderColor: currentTheme.colors.surface0,
          borderWidth: '1px',
          borderStyle: 'solid'
        }}
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ duration: 0.5, delay: 0.3 }}
      >
        <h3 className="text-2xl font-semibold mb-4" style={{ color: currentTheme.colors.text }}>
          🔮 Tools Working Together
        </h3>
        <p className="mb-4" style={{ color: currentTheme.colors.subtext0 }}>
          The true power of this setup comes from how these tools work together to create a seamless development experience.
          Tmux sessions persist your work, Neovim provides powerful editing capabilities, and everything is themed consistently with Catppuccin.
        </p>
        <div className="p-4 rounded-lg font-mono text-sm" style={{ backgroundColor: currentTheme.colors.mantle }}>
          <div style={{ color: currentTheme.colors.green }}>$ tmux new-session -s dev</div>
          <div style={{ color: currentTheme.colors.green }}>$ nvim .</div>
          <div style={{ color: currentTheme.colors.mauve }}># Your cosmic development journey begins...</div>
        </div>
      </motion.div>
    </div>
  );
};

export default DotfilesShowcase;
