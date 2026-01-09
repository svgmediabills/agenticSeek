# Base image
FROM ubuntu:22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install base dependencies
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
    chromium-browser chromium-chromedriver \
    && ln -s /usr/bin/chromium-browser /usr/bin/google-chrome \
    && ln -s /usr/lib/chromium-browser/chromedriver /usr/local/bin/chromedriver \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy repo
COPY . .

# Install Python dependencies WITHOUT PyAudio
RUN pip3 install --upgrade pip
RUN pip3 install $(grep -v 'pyaudio' requirements.txt)

# Install frontend dependencies
WORKDIR /app/frontend
RUN npm install --legacy-peer-deps
WORKDIR /app

# Make the start script executable
RUN chmod +x ./start_services.sh

# Expose required ports
EXPOSE 7777 3000 8080 6379

# Set environment variables for lightweight mode
ENV LISTEN=False
ENV SPEAK=False
ENV SAVE_SESSION=False

# Lightweight startup: Redis + backend + frontend + SearxNG
CMD ["./start_services.sh", "full"]
