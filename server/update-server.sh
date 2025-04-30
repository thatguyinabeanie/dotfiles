#!/bin/bash

# Navigate to the server directory
cd "$(dirname "$0")"

# Pull the latest changes from the repository
echo "Pulling the latest changes from the repository..."
cd ..
git pull

# Navigate back to the server directory
cd .server

# Install dependencies
echo "Installing dependencies..."
npm install

# Build the application
echo "Building the application..."
npm run build

# Restart the server if it's running with PM2
if command -v pm2 &> /dev/null; then
    echo "Restarting the server with PM2..."
    pm2 restart dotfiles-server || pm2 start npm --name "dotfiles-server" -- start
else
    echo "PM2 is not installed. You can restart the server manually."
fi

echo "Server update complete!"
