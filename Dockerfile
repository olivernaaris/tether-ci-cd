# Stage 1: Builder
FROM node:22-slim AS builder

# Build arguments
ARG NODE_ENV=development
ARG WORKER_TYPE=wrk-node-http
ARG PORT=3000
ARG DEBUG=false

# Create non-root user for security
RUN groupadd --gid 3000 app && \
    useradd --uid 10001 --gid 3000 --create-home app

# Set working directory
WORKDIR /app

# Install system dependencies if needed
RUN apt-get update && apt-get install -y git && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy package files first for better layer caching
COPY --chown=app:app package*.json ./

# Install dependencies with npm cache mount for faster rebuilds
RUN --mount=type=cache,target=/root/.npm \
    npm ci --only=${NODE_ENV} --no-audit --no-fund

# Copy source code
COPY --chown=app:app . .

# Stage 2: Runtime
FROM node:22-slim

# Build arguments
ARG NODE_ENV=development
ARG WORKER_TYPE=wrk-node-http
ARG PORT=3000
ARG DEBUG=false

# Create non-root user for security
RUN groupadd --gid 3000 app && \
    useradd --uid 10001 --gid 3000 --create-home app

# Set working directory
WORKDIR /app

# Copy built application from builder stage
COPY --from=builder --chown=app:app /app /app

# Set environment variables
ENV NODE_ENV=${NODE_ENV}

# Use non-root user
USER app

# Expose port
EXPOSE ${PORT}

# Default command
CMD ["node", "worker.js", "--wtype", "${WORKER_TYPE}", "--env", "${NODE_ENV}", "--port", "${PORT}"]