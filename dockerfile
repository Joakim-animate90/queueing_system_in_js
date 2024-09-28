# Use Ubuntu 18.04 as the base image
FROM ubuntu:18.04

# Install dependencies required for Redis, Node.js, and wget
RUN apt-get update && \
    apt-get install -y build-essential tcl wget curl \
    && apt-get clean

# Install Redis (6.0.10 as per your request)
RUN wget http://download.redis.io/releases/redis-6.0.10.tar.gz && \
    tar xzf redis-6.0.10.tar.gz && \
    cd redis-6.0.10 && \
    make && \
    make install && \
    cd .. && \
    rm -rf redis-6.0.10.tar.gz redis-6.0.10

# Install Node.js (12.x version for Ubuntu 18.04)
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean

# Create an app directory and set it as the working directory
WORKDIR /usr/src/app

# Copy your package.json and package-lock.json files to the container
COPY package*.json ./

# Install app dependencies
RUN npm install

# Copy the rest of your application code to the working directory
COPY . .

# Expose the port that Redis and the application will run on
EXPOSE 6379

# Start Redis server and the application
CMD redis-server --daemonize yes && npm start
