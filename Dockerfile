# =========================
# Build Stage
# =========================
FROM node:20-bookworm-slim AS builder

WORKDIR /app

# Copy package files first for better caching
COPY package.json package-lock.json ./

# Clean install from lockfile
RUN npm ci --include=optional

# Copy source
COPY . .

# Build application
RUN npm run build

# =========================
# Production Stage
# =========================
FROM nginx:1.27-alpine

# Copy built assets
COPY --from=builder /app/dist /usr/share/nginx/html

# Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]