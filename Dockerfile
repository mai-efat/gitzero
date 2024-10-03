#step 1: Build the Nuxt.js application
FROM node:16 AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Nuxt.js application
RUN npm run build

# Step 2: Set up the Nuxt.js application
FROM node:16

WORKDIR /app

# Copy only the necessary files from the builder
COPY --from=builder /app .

# Install production dependencies
RUN npm install --production

# Expose the application port (default is 3000)
EXPOSE 3000

# Start the Nuxt.js application
CMD ["npm", "start"]
