"use client";

import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { Prism as SyntaxHighlighter } from 'react-syntax-highlighter';
import { atomDark } from 'react-syntax-highlighter/dist/cjs/styles/prism';
import Typewriter from 'typewriter-effect';
import { useTheme } from '@/context/ThemeContext';

interface TerminalWindowProps {
  title?: string;
  commands?: string[];
  codeSnippet?: {
    code: string;
    language: string;
    filename: string;
  };
}

const TerminalWindow: React.FC<TerminalWindowProps> = ({
  title = 'terminal',
  commands = [],
  codeSnippet,
}) => {
  const { currentTheme } = useTheme();
  const [currentCommandIndex, setCurrentCommandIndex] = useState(0);
  const [showCode, setShowCode] = useState(false);

  useEffect(() => {
    if (currentCommandIndex >= commands.length && codeSnippet) {
      const timer = setTimeout(() => {
        setShowCode(true);
      }, 1000);
      return () => clearTimeout(timer);
    }
  }, [currentCommandIndex, commands.length, codeSnippet]);

  return (
    <motion.div
      className="w-full rounded-lg overflow-hidden shadow-lg mb-8"
      style={{
        backgroundColor: currentTheme.colors.crust,
        borderColor: currentTheme.colors.surface0,
        borderWidth: '1px',
        borderStyle: 'solid'
      }}
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5 }}
    >
      {/* Terminal Header */}
      <div className="px-4 py-2 flex items-center" style={{ backgroundColor: currentTheme.colors.mantle }}>
        <div className="flex space-x-2 mr-4">
          <div className="w-3 h-3 rounded-full" style={{ backgroundColor: currentTheme.colors.red }}></div>
          <div className="w-3 h-3 rounded-full" style={{ backgroundColor: currentTheme.colors.yellow }}></div>
          <div className="w-3 h-3 rounded-full" style={{ backgroundColor: currentTheme.colors.green }}></div>
        </div>
        <div className="text-sm font-mono" style={{ color: currentTheme.colors.subtext0 }}>{title}</div>
      </div>

      {/* Terminal Content */}
      <div className="p-4 font-mono text-sm min-h-[200px]" style={{ color: currentTheme.colors.text }}>
        {commands.map((command, index) => (
          <div key={index} className={index > currentCommandIndex ? 'hidden' : ''}>
            <div className="flex">
              <span style={{ color: currentTheme.colors.green }} className="mr-2">$</span>
              {index === currentCommandIndex ? (
                <Typewriter
                  onInit={(typewriter) => {
                    typewriter
                      .typeString(command)
                      .callFunction(() => {
                        setCurrentCommandIndex(index + 1);
                      })
                      .start();
                  }}
                  options={{
                    delay: 50,
                    cursor: '▋',
                  }}
                />
              ) : (
                <span>{command}</span>
              )}
            </div>
            {index < currentCommandIndex && <div className="my-1"></div>}
          </div>
        ))}

        {showCode && codeSnippet && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.5 }}
            className="mt-4"
          >
            <div className="mb-2" style={{ color: currentTheme.colors.blue }}># {codeSnippet.filename}</div>
            <SyntaxHighlighter
              language={codeSnippet.language}
              style={atomDark}
              customStyle={{
                background: 'transparent',
                padding: '1rem',
                color: currentTheme.colors.text
              }}
              showLineNumbers
            >
              {codeSnippet.code}
            </SyntaxHighlighter>
          </motion.div>
        )}
      </div>
    </motion.div>
  );
};

export default TerminalWindow;
