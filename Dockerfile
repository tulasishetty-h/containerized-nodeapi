# Use small Node 18 image
FROM node:18-alpine

# Create app directory
WORKDIR /app

# Add a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy package files first (cache npm install)
COPY package*.json ./

# Install only prod dependencies (faster builds)
RUN npm install --production

# Copy application source
COPY . .

# Change ownership to non-root user and switch to it
RUN chown -R appuser:appgroup /app
USER appuser

# Expose port and declare default env
EXPOSE 3000
ENV NODE_ENV=production

# Simple healthcheck (optional, supported by Docker)
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost:3000/users || exit 1

# Start the app
CMD ["node", "index.js"]
