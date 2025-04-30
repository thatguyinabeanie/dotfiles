#!/bin/bash

# Navigate to the server directory
cd "$(dirname "$0")"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker to run this server."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Please install Docker Compose to run this server."
    exit 1
fi

# Build and start the Docker container
echo "Building and starting the Docker container..."
docker-compose up --build
