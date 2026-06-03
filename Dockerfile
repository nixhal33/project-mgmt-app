# =========================
# Build stage
# =========================
FROM node:20-bookworm-slim AS builder

WORKDIR /app

# Copy only dependency files first (better cache + stability)
COPY package.json package-lock.json ./

# VERY IMPORTANT: force full dependency + optional deps + no pruning
RUN npm ci --include=optional --force

# Defensive fix: ensure rollup native binaries are correctly resolved
RUN npm rebuild rollup

# Copy source
COPY . .

# Build
RUN npm run build

# =========================
# Production stage
# =========================
FROM nginx:1.27-alpine

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]