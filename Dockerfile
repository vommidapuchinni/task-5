# Use an official Node.js runtime as a parent image
FROM node:16

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install any needed packages
RUN npm install

# Copy the rest of your application code
COPY . .

# Expose port 9000 for the Medusa service
EXPOSE 9000

# Define environment variable defaults
ENV JWT_SECRET=something
ENV COOKIE_SECRET=something
ENV DATABASE_TYPE=postgres
ENV DATABASE_URL=postgres://postgres:chinni@postgres:5432/medusa_db
ENV REDIS_URL=redis://redis:6379

# Run Medusa application
CMD [ "npx", "medusa", "develop" ]

