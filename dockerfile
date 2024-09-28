# Use Ubuntu 18.04 as the base image
FROM ubuntu:18.04

# Set environment variable to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Redis and Node.js 12.x
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    software-properties-common \
    build-essential

# Install Redis 5.0.7
RUN apt-get install -y redis-server=5:5.0.7*

# Install Node.js 12.x
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install -y nodejs

# Install Babel for ES6 support
RUN npm install -g @babel/core @babel/cli @babel/preset-env

# Create and set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install Node.js dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the port for Redis (optional if Redis will be accessed externally)
EXPOSE 6379

# Start Redis server and run the script with Babel
CMD service redis-server start && npx babel-node 0-redis_client.js
