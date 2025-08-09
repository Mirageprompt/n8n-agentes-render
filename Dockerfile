# Dockerfile otimizado para Render
FROM n8nio/n8n:0.234.0

# Setup for Render
USER root

# Install dependencies
RUN apk add --no-cache \
    curl \
    tini

# Create proper directories
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node

# Switch to node user
USER node
WORKDIR /home/node/.n8n

# Environment variables
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
ENV N8N_HIRING_BANNER_ENABLED=false
ENV N8N_SECURE_COOKIE=false

# Expose port
EXPOSE ${PORT:-5678}

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
  CMD curl -f http://localhost:${PORT:-5678}/healthz || exit 1

# Start command
ENTRYPOINT ["tini", "--"]
CMD ["/docker-entrypoint.sh", "n8n"]