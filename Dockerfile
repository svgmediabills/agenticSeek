# Base image
FROM ubuntu:22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    python3.10 python3-pip python3-venv \
    curl unzip git wget \
    redis-server \
    gnupg ca-certificates \
    nodejs npm \
    curl unzip xz-utils libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 \
    libxkbcommon0 libxcomposite1 libxdamage1 libxrandr2 libxshmfence1 libgbm1 \
    libpango-1.0-0 libpangocairo-1.0-0 libgtk-3-0 xvfb \
    portaudio19-dev libasound2-dev \
    chromium-browser chromium-chromedriver \
    && ln -s /usr/bin/chromium-browser /usr/bin/google-chrome \
    && ln -s /usr/lib/chromium-browser/chromedriver /usr/local/bin/chromedriver \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy repo
COPY . .

# Install Python dependencies
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt

# Install frontend dependencies
WORKDIR /app/frontend
RUN npm install
WORKDIR /app

# Make the start script executable
RUN chmod +x ./start_services.sh

# Expose ports
EXPOSE 7777 3000 8080 6379

# Start all services
CMD ["./start_services.sh", "full"]
