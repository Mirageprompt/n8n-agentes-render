# Dockerfile compatível com Render
FROM node:18-alpine

# Install system dependencies
RUN apk add --no-cache \
    curl \
    git \
    python3 \
    make \
    g++ \
    tini

# Install n8n globally
RUN npm install -g n8n@0.234.0

# Create app directory
WORKDIR /app

# Environment variables for Render
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=${PORT:-5678}
ENV N8N_PROTOCOL=https
ENV N8N_BASIC_AUTH_ACTIVE=true
ENV N8N_BASIC_AUTH_USER=admin
ENV N8N_BASIC_AUTH_PASSWORD=agentes123
ENV DB_TYPE=sqlite
ENV N8N_LOG_LEVEL=info
ENV N8N_PUBLIC_API_DISABLED=false
ENV N8N_DIAGNOSTICS_ENABLED=false
ENV N8N_VERSION_NOTIFICATIONS_ENABLED=false

# Create n8n data directory
RUN mkdir -p /app/.n8n && chmod 755 /app/.n8n

# Expose port
EXPOSE ${PORT:-5678}

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
  CMD curl -f http://localhost:${PORT:-5678}/healthz || exit 1

# Start command without user switching
CMD ["n8n", "start"]