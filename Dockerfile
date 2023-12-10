# Stage 1: Build the project
FROM node:21-alpine AS build

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

ENV VITE_API_URL=http://localhost:8080

# Install dependencies
RUN npm install

# Copy project files
COPY . .

# Build the project
RUN npm run build

# Stage 2: Serve the app using Nginx
FROM nginx:alpine

# Set working directory to Nginx asset directory
WORKDIR /usr/share/nginx/html

# Remove default Nginx static assets
RUN rm -rf ./*

# Copy static assets from builder stage
COPY --from=build /app/build .

# Copy custom Nginx configuration file
COPY default.conf /etc/nginx/conf.d/default.conf

# Change ownership and permissions of the files
# This step ensures Nginx can read the files
RUN chown nginx:nginx ./* && chmod -R 755 ./*

# Expose port 80
EXPOSE 80

# Start Nginx and keep it running
CMD ["nginx", "-g", "daemon off;"]
