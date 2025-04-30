"use client";

import React from 'react';
import { motion } from 'framer-motion';

interface FeatureCardProps {
  title: string;
  description: string;
  icon: string;
  index?: number;
}

const FeatureCard: React.FC<FeatureCardProps> = ({ title, description, icon, index = 0 }) => {
  return (
    <motion.div
      className="bg-gray-800/80 backdrop-blur-sm rounded-lg p-6 border border-gray-700 hover:border-purple-500 transition-all hover:shadow-lg hover:shadow-purple-500/20"
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5, delay: index * 0.1 }}
      whileHover={{
        scale: 1.03,
        transition: { duration: 0.2 }
      }}
    >
      <div className="flex items-center mb-4">
        <motion.span
          className="text-3xl mr-4 bg-gray-700 p-2 rounded-lg text-purple-400"
          whileHover={{ rotate: [0, -10, 10, -10, 0] }}
          transition={{ duration: 0.5 }}
        >
          {icon}
        </motion.span>
        <h3 className="text-xl font-medium">{title}</h3>
      </div>
      <p className="text-gray-300">{description}</p>

      <motion.div
        className="mt-4 text-purple-400 text-sm font-medium cursor-pointer"
        whileHover={{ x: 5 }}
      >
        Learn more →
      </motion.div>
    </motion.div>
  );
};

export default FeatureCard;
