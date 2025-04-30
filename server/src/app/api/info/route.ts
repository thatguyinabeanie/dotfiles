import { NextResponse } from 'next/server';

export async function GET() {
  const data = {
    name: 'Dotfiles Showcase',
    description: 'A cosmic development environment',
    features: [
      {
        name: 'Neovim',
        description: 'Modern, powerful text editor',
        category: 'editor'
      },
      {
        name: 'Tmux',
        description: 'Terminal multiplexer for productivity',
        category: 'terminal'
      },
      {
        name: 'Nushell',
        description: 'Modern shell with data processing capabilities',
        category: 'shell'
      },
      {
        name: 'K9s',
        description: 'Kubernetes CLI to manage your clusters',
        category: 'devops'
      },
      {
        name: 'Catppuccin',
        description: 'Soothing pastel theme for development environment',
        category: 'theme'
      }
    ],
    repository: 'https://github.com/thatguyinabeanie/dotfiles'
  };

  return NextResponse.json(data);
}
