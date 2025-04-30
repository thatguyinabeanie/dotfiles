import Image from 'next/image'
import styles from './page.module.css'
import DotfilesShowcase from '@/components/DotfilesShowcase'

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center p-8 md:p-24">
      <div className="z-10 max-w-6xl w-full items-center">
        <div className="text-center mb-16">
          <h1 className="text-5xl font-bold mb-4">
            🚀 Dotfiles Showcase
          </h1>
          <p className="text-xl text-gray-300 max-w-3xl mx-auto">
            A cosmic journey through my development environment
          </p>
        </div>

        <div className="bg-gray-800/50 backdrop-blur-sm rounded-lg p-8 mb-12 border border-gray-700">
          <h2 className="text-3xl font-semibold mb-6">✨ Cosmic Development Environment</h2>
          <p className="text-lg mb-6">
            A modern and efficient development environment setup that's out of this world!
            Managed with Chezmoi for seamless configuration across machines.
          </p>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mt-8">
            <div className="border border-gray-700 rounded-lg p-6 bg-gray-800/30">
              <h3 className="text-2xl font-medium mb-4">🛠️ Tools</h3>
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
            </div>

            <div className="border border-gray-700 rounded-lg p-6 bg-gray-800/30">
              <h3 className="text-2xl font-medium mb-4">🎨 Themes</h3>
              <p className="mb-4">
                Featuring the beautiful Catppuccin theme across all applications
                for a consistent and pleasing visual experience.
              </p>
              <div className="flex space-x-2 mt-4">
                <div className="w-8 h-8 rounded-full bg-[#f5c2e7]" title="Pink"></div>
                <div className="w-8 h-8 rounded-full bg-[#cba6f7]" title="Mauve"></div>
                <div className="w-8 h-8 rounded-full bg-[#f38ba8]" title="Red"></div>
                <div className="w-8 h-8 rounded-full bg-[#fab387]" title="Peach"></div>
                <div className="w-8 h-8 rounded-full bg-[#a6e3a1]" title="Green"></div>
                <div className="w-8 h-8 rounded-full bg-[#89dceb]" title="Sky"></div>
              </div>
            </div>
          </div>
        </div>

        <DotfilesShowcase />

        <div className="text-center mt-12">
          <a
            href="https://github.com/thatguyinabeanie/dotfiles"
            className="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors text-lg font-medium"
            target="_blank"
            rel="noopener noreferrer"
          >
            View on GitHub
          </a>
        </div>
      </div>
    </main>
  )
}
