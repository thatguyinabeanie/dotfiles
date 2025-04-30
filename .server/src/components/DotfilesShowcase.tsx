import React from 'react';
import FeatureCard from './FeatureCard';

const DotfilesShowcase: React.FC = () => {
  const features = [
    {
      title: 'Neovim',
      description: 'Modern text editor with powerful plugins and customizations',
      icon: '📝'
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
      title: 'Catppuccin Theme',
      description: 'Soothing pastel theme for all applications',
      icon: '🎨'
    },
    {
      title: 'Chezmoi',
      description: 'Dotfiles manager for seamless configuration across machines',
      icon: '🏠'
    }
  ];

  return (
    <div className="py-12">
      <h2 className="text-3xl font-bold text-center mb-8">Features</h2>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {features.map((feature, index) => (
          <FeatureCard
            key={index}
            title={feature.title}
            description={feature.description}
            icon={feature.icon}
          />
        ))}
      </div>
    </div>
  );
};

export default DotfilesShowcase;
