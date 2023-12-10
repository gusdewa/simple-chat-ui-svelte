# Base image
FROM node:latest as build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy project files
COPY . .

# Build the app
RUN npm run build

# Final image
FROM node:latest

WORKDIR /app

# Copy build from the previous stage
COPY --from=build /app/build ./build
COPY --from=build /app/node_modules ./node_modules

# Expose the port the app runs on
EXPOSE 3000

# Start the app
CMD ["node", "build"]
