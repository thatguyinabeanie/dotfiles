"use client";

import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { Prism as SyntaxHighlighter } from 'react-syntax-highlighter';
import { atomDark } from 'react-syntax-highlighter/dist/cjs/styles/prism';
import Typewriter from 'typewriter-effect';

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
      className="w-full rounded-lg overflow-hidden shadow-lg border border-gray-700 bg-gray-900 mb-8"
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5 }}
    >
      {/* Terminal Header */}
      <div className="bg-gray-800 px-4 py-2 flex items-center">
        <div className="flex space-x-2 mr-4">
          <div className="w-3 h-3 rounded-full bg-red-500"></div>
          <div className="w-3 h-3 rounded-full bg-yellow-500"></div>
          <div className="w-3 h-3 rounded-full bg-green-500"></div>
        </div>
        <div className="text-gray-400 text-sm font-mono">{title}</div>
      </div>

      {/* Terminal Content */}
      <div className="p-4 font-mono text-sm text-gray-300 min-h-[200px]">
        {commands.map((command, index) => (
          <div key={index} className={index > currentCommandIndex ? 'hidden' : ''}>
            <div className="flex">
              <span className="text-green-400 mr-2">$</span>
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
            <div className="text-blue-400 mb-2"># {codeSnippet.filename}</div>
            <SyntaxHighlighter
              language={codeSnippet.language}
              style={atomDark}
              customStyle={{ background: 'transparent', padding: '1rem' }}
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
