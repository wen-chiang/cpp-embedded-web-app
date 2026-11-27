# Docker & Docker Compose Setup Guide

Complete guide to running the C++ Embedded Web App in Docker.

## Overview

This project includes Docker support for easy deployment without local environment setup.

**Key Benefits:**
- ✓ No local C++ compiler needed
- ✓ No local build tools needed
- ✓ Runs on any machine with Docker
- ✓ Consistent environment (Linux)
- ✓ Easy to deploy to cloud
- ✓ Production-ready setup

## Prerequisites

Install Docker and Docker Compose:

### Option 1: Docker Desktop (Easiest)

Download: https://www.docker.com/products/docker-desktop

Includes both Docker Engine and Docker Compose.

Verify:
```powershell
docker --version
docker-compose --version
```

### Option 2: Docker Engine + Compose (Linux)

```bash
sudo apt-get install docker.io docker-compose
```

## Quick Start

### Build and Run with Docker Compose

```powershell
cd C:\Wrok_Zone\cpp-embedded-web-app

# Build and run
docker-compose up --build

# Or run in background
docker-compose up -d --build
```

The application will start and be available at: `http://localhost:8080`

### Stop the Container

```powershell
# Stop (preserves container)
docker-compose stop

# Stop and remove (clean up)
docker-compose down

# Stop and remove everything (volumes, networks, etc.)
docker-compose down -v
```

## How It Works

### Multi-Stage Build

The Dockerfile uses a multi-stage build:

1. **Stage 1: Builder**
   - Starts with `ubuntu:24.04`
   - Installs build tools (gcc, cmake, python3)
   - Installs Conan package manager
   - Downloads dependencies via Conan
   - Compiles the C++ application
   - Creates executable

2. **Stage 2: Runtime**
   - Starts with clean `ubuntu:24.04`
   - Installs only runtime libraries (not build tools)
   - Copies compiled executable
   - Runs the application
   - **Result:** Small, efficient image

**Benefits:**
- ✓ Smaller final image (no build tools in runtime)
- ✓ Faster deployment
- ✓ Security (no compiler in production)
- ✓ Cleaner environment

## Docker Compose Features

The `docker-compose.yml` includes:

### Port Mapping
```yaml
ports:
  - "8080:8080"  # Host:Container
```
Access at: `http://localhost:8080`

### Health Check
```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:8080/"]
  interval: 30s
  timeout: 3s
  retries: 3
```
Automatically restarts if service becomes unhealthy.

### Restart Policy
```yaml
restart: unless-stopped
```
Container restarts automatically on failure (unless you explicitly stop it).

### Logging
```yaml
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```
Limits log file size to prevent disk space issues.

## Common Commands

### Build the Docker Image

```powershell
# Build only (don't run)
docker-compose build

# Build with no cache (fresh build)
docker-compose build --no-cache
```

### View Running Containers

```powershell
docker-compose ps
```

Output:
```
NAME                      COMMAND                 STATUS
cpp-embedded-web-app      "./cpp_embedded_web"    Up 5 minutes
```

### View Logs

```powershell
# View logs
docker-compose logs

# View logs with follow (live updates)
docker-compose logs -f

# View last 50 lines
docker-compose logs --tail=50
```

### Execute Commands in Container

```powershell
# Interactive shell
docker-compose exec cpp-web-app sh

# Run specific command
docker-compose exec cpp-web-app curl http://localhost:8080/api/message
```

### Remove Everything

```powershell
# Remove containers, networks (keeps images)
docker-compose down

# Remove everything including images
docker-compose down --rmi all

# Remove everything including volumes
docker-compose down -v --rmi all
```

## Testing

### From Host Machine

```powershell
# Test web interface
curl http://localhost:8080

# Test API endpoint
curl http://localhost:8080/api/message
# Or in PowerShell:
Invoke-RestMethod http://localhost:8080/api/message
```

### From Inside Container

```powershell
# Interactive shell
docker-compose exec cpp-web-app sh

# Inside container:
curl http://localhost:8080/api/message
```

## Troubleshooting

### Build Fails: "Permission Denied"

**Cause:** Docker daemon not running.

**Solution (Windows/Mac):**
- Open Docker Desktop
- Wait for "Docker is running" message

**Solution (Linux):**
```bash
sudo systemctl start docker
# Or use sudo with docker commands:
sudo docker-compose up --build
```

### Port Already In Use

**Cause:** Port 8080 is already in use.

**Solution 1:** Stop the conflicting service

```powershell
# Find what's using port 8080
netstat -ano | findstr :8080

# Kill the process
taskkill /PID <PID> /F
```

**Solution 2:** Use different port

Edit `docker-compose.yml`:
```yaml
ports:
  - "8081:8080"  # Use 8081 on host, 8080 in container
```

Then access at: `http://localhost:8081`

### Container Exits Immediately

**Check logs:**
```powershell
docker-compose logs

# Or view last 20 lines
docker-compose logs --tail=20
```

**Common causes:**
- Compilation failed (check build logs)
- Port already in use
- Missing dependency

**Solution:** Rebuild with no cache:
```powershell
docker-compose down
docker-compose build --no-cache
docker-compose up
```

### Image Too Large

**Cause:** Including unnecessary files or build tools in runtime.

**Solution:** Already solved! Multi-stage build keeps image small.

**Check image size:**
```powershell
docker images
# Look for cpp-embedded-web-app size
```

Expected: ~200-300 MB (depending on base image)

## Performance Optimization

### Resource Limits (Optional)

Uncomment in `docker-compose.yml`:

```yaml
deploy:
  resources:
    limits:
      cpus: '0.5'        # Max 50% of one CPU
      memory: 256M       # Max 256 MB RAM
    reservations:
      cpus: '0.25'       # Reserve 25% CPU
      memory: 128M       # Reserve 128 MB RAM
```

### Production Deployment

For production:

1. **Use specific base image version** (not latest)
   ```dockerfile
   FROM ubuntu:24.04  # Good
   # NOT: FROM ubuntu:latest
   ```

2. **Run as non-root user** (security best practice)
   ```dockerfile
   RUN useradd -m appuser
   USER appuser
   ```

3. **Set resource limits** (prevent runaway processes)
   ```yaml
   deploy:
     resources:
       limits:
         memory: 512M
   ```

4. **Enable logging** (already configured)
   ```yaml
   logging:
     driver: "json-file"
   ```

5. **Use health checks** (already configured)
   ```yaml
   healthcheck:
     test: ["CMD", "curl", "-f", "http://localhost:8080/"]
   ```

## Docker Hub & Public Images

### Our Setup

This project **does NOT use pre-built public images**. Instead:
- It **builds from source** using Ubuntu base image
- Compiles the C++ application
- Creates a custom image specific to this project

**Why?**
- ✓ Self-contained (all dependencies included)
- ✓ Reproducible builds
- ✓ No external dependencies
- ✓ Full control over environment

### If You Want to Share

You can push to Docker Hub:

```powershell
# Login to Docker Hub
docker login

# Tag image
docker tag cpp-embedded-web-app:latest YOUR_USERNAME/cpp-embedded-web-app:latest

# Push to Docker Hub
docker push YOUR_USERNAME/cpp-embedded-web-app:latest

# Others can then run:
docker run -p 8080:8080 YOUR_USERNAME/cpp-embedded-web-app:latest
```

## Production Deployment

### Deploy to Cloud

#### Option 1: AWS ECS (Elastic Container Service)
```bash
# Push to Amazon ECR
aws ecr get-login-password | docker login --username AWS --password-stdin <ecr-url>
docker tag cpp-embedded-web-app:latest <ecr-url>/cpp-embedded-web-app:latest
docker push <ecr-url>/cpp-embedded-web-app:latest
```

#### Option 2: Google Cloud Run
```bash
# Push to Google Container Registry
docker tag cpp-embedded-web-app:latest gcr.io/<project>/cpp-embedded-web-app
docker push gcr.io/<project>/cpp-embedded-web-app
# Deploy via Cloud Run console
```

#### Option 3: Azure Container Instances
```bash
# Push to Azure Container Registry
docker tag cpp-embedded-web-app:latest <registry>.azurecr.io/cpp-embedded-web-app
docker push <registry>.azurecr.io/cpp-embedded-web-app
```

#### Option 4: Kubernetes
```bash
# Create deployment.yaml
# Apply: kubectl apply -f deployment.yaml
# See examples/kubernetes/ for details
```

## Image Comparison

| Aspect | Local Build | Docker Build |
|--------|------------|--------------|
| **Setup Time** | 30+ min | 5-10 min |
| **Platform** | Windows only | Linux/Windows/Mac |
| **Dependencies** | Compiler, CMake, Conan | Only Docker |
| **Consistency** | May vary by system | Always identical |
| **Deployment** | Manual to servers | One command to cloud |
| **Team Usage** | Each installs tools | "docker-compose up" |

## Base Images Used

### Ubuntu 24.04 (Chosen)
- **Size:** ~77 MB (builder), ~40 MB (runtime)
- **Pros:** Latest tools, good support, balanced
- **Cons:** Larger than Alpine
- **Use for:** Production, stability, compatibility

### Alternatives

**Alpine 3.19** (Smallest)
```dockerfile
FROM alpine:3.19
# Smaller (~150 MB total) but may need extra packages
```

**Debian 12 (Bookworm)** (Standard)
```dockerfile
FROM debian:12-slim
# Common in production, good library support
```

**CentOS 9 Stream** (Enterprise)
```dockerfile
FROM quay.io/centos/centos:stream9
# Enterprise Linux environment
```

## Development vs Production

### Development Setup (Current)

```yaml
# docker-compose.yml (development)
ports:
  - "8080:8080"
restart: unless-stopped
```

### Production Setup (Advanced)

```yaml
# docker-compose.prod.yml
ports:
  - "8080"  # Don't expose directly
restart: always
deploy:
  resources:
    limits:
      memory: 512M
      cpus: '1'
logging:
  options:
    max-size: "50m"  # Larger in production
healthcheck:
  interval: 10s  # More frequent checks
  retries: 5
```

Then deploy with:
```bash
docker-compose -f docker-compose.prod.yml up -d
```

## Summary

| Task | Command |
|------|---------|
| Build & Run | `docker-compose up --build` |
| Run (background) | `docker-compose up -d` |
| Stop | `docker-compose stop` |
| View logs | `docker-compose logs -f` |
| Execute command | `docker-compose exec cpp-web-app <cmd>` |
| Remove all | `docker-compose down -v` |

## Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Multi-stage Builds Guide](https://docs.docker.com/build/building/multi-stage/)

---

**Status:** ✅ Docker ready for local development and cloud deployment  
**Image Type:** Multi-stage build (optimized)  
**Base:** Ubuntu 24.04  
**Size:** ~300 MB
