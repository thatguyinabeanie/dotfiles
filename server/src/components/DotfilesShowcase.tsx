"use client";

import React from 'react';
import { motion } from 'framer-motion';
import FeatureCard from './FeatureCard';
import TerminalWindow from './TerminalWindow';
import ThemeSwitcher from './ThemeSwitcher';

const DotfilesShowcase: React.FC = () => {
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

      <ThemeSwitcher />

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
        className="mt-16 p-6 bg-gray-800/50 backdrop-blur-sm rounded-lg border border-gray-700"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ duration: 0.5, delay: 0.3 }}
      >
        <h3 className="text-2xl font-semibold mb-4">🔮 Tools Working Together</h3>
        <p className="text-gray-300 mb-4">
          The true power of this setup comes from how these tools work together to create a seamless development experience.
          Tmux sessions persist your work, Neovim provides powerful editing capabilities, and everything is themed consistently with Catppuccin.
        </p>
        <div className="bg-gray-900 p-4 rounded-lg font-mono text-sm">
          <div className="text-green-400">$ tmux new-session -s dev</div>
          <div className="text-green-400">$ nvim .</div>
          <div className="text-purple-400"># Your cosmic development journey begins...</div>
        </div>
      </motion.div>
    </div>
  );
};

export default DotfilesShowcase;
