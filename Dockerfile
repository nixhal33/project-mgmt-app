# New Dockerfile Added
# 1. CHANGE THIS LINE from alpine to slim
FROM node:20-slim AS builder
WORKDIR /app
COPY package*.json ./

# 2. This will now run perfectly without crashing
RUN npm ci
COPY . .
RUN npm run build

# Serve stage (Keep this Nginx Alpine image exactly as it is!) 
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]