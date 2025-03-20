# Document how OIDC is setup

# Dockerfile Documentation
This document explains the structure and purpose of the services Dockerfile. The Dockerfile is split into two main stages: a **build stage** and a **production stage**. This multi-stage build approach enhances efficiency, security, and maintainability.

---

## Overview

The Dockerfile uses a multi-stage build process to create a lightweight production image for a Nestjs application. It leverages the `node:20-alpine` base image for both stages to keep the image size small while ensuring consistency across environments.

## Build Stage

The **build stage** is responsible for compiling the application (parse typescript to javascript) and preparing the production-ready assets. It is labeled as `builder`.

```dockerfile
#Build stage
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build
```

## Key Steps in the Build Stage

- **Base Image (`node:20-alpine`)**  
  Uses Alpine node, which is a minimal and lightweight image, reducing the overall image size and speeding up build times.

- **Setting the Working Directory (`WORKDIR /app`)**  
  Establishes `/app` as the context for all subsequent commands, ensuring a clean and organized file structure.

- **Copying Dependency Files (`COPY package*.json ./`)**  
  Copies `package.json` and `package-lock.json` files to the container. This allows Docker to cache dependency installation if these files haven't changed.

- **Installing Dependencies (`RUN npm ci`)**  
  Uses `npm ci` to install dependencies. This command is preferred for CI/CD pipelines because it installs exact versions from the package-lock.json file, ensuring a reproducible environment.

- **Copying the Source Code (`COPY . .`)**  
  Copies the entire application code into the container.

- **Building the Application (`RUN npm run build`)**  
  Executes the build script defined in `package.json`. The output (typically placed in `/app/dist`) is what will be used in the production stage.