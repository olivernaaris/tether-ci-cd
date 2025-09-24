FROM node:22-slim AS base

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libatomic1 \
    && rm -rf /var/lib/apt/lists/*

FROM base AS builder

# Set working directory
WORKDIR /app

# Copy files from working directory
COPY . .

# Prune the monorepo to only include necessary files
RUN npx -y turbo prune app-node --docker

FROM base AS installer

# Set working directory
WORKDIR /app

# Copy pruned files from builder stage
COPY --from=builder /app/out/json/ .
COPY --from=builder /app/out/package-lock.json ./package-lock.json

# Install dependencies with npm cache mount for faster rebuilds
RUN --mount=type=cache,target=/root/.npm \
    npm ci --no-audit --no-fund

# Copy source and build
COPY --from=builder /app/out/full/ .
RUN npm run build --workspaces --if-present && npm prune --production

FROM base AS runner

# Create non-root user for security
RUN groupadd --gid 3000 app && \
    useradd --uid 10001 --gid 3000 --create-home app

# Set working directory
WORKDIR /app/services/app-node

# Copy built application from installer stage
COPY --from=installer --chown=app:app /app /app

# Use non-root user
USER app

# Expose port
EXPOSE 3000

# Setup config
RUN chmod +x setup-config.sh && ./setup-config.sh