# Docker Quick Reference

Fast commands for Docker and Docker Compose.

## Installation

### Windows / Mac
1. Download: https://www.docker.com/products/docker-desktop
2. Install and launch
3. Verify: `docker --version`

### Linux
```bash
sudo apt-get install docker.io docker-compose
sudo usermod -aG docker $USER  # Add user to docker group
```

---

## Quick Start

### Run with Docker Compose

```bash
# Build and run
docker-compose up --build

# Run in background
docker-compose up -d --build

# Stop
docker-compose stop

# Remove everything
docker-compose down
```

Access at: **http://localhost:8080**

---

## Essential Commands

### View Status
```bash
docker-compose ps                 # Show running containers
docker-compose logs               # Show container logs
docker-compose logs -f            # Follow logs (live)
```

### Execute Commands
```bash
docker-compose exec cpp-web-app curl http://localhost:8080
docker-compose exec cpp-web-app sh                      # Interactive shell
```

### Build & Push
```bash
docker-compose build              # Build image
docker build -t my-app:latest .   # Build specific image
docker push username/my-app       # Push to Docker Hub
```

### Clean Up
```bash
docker-compose down               # Stop and remove containers
docker system prune               # Remove unused images/volumes
docker system prune -a            # Remove all unused
```

---

## Common Use Cases

### Development (Local Testing)
```bash
docker-compose up --build
# App available at http://localhost:8080
```

### Production (Background)
```bash
docker-compose up -d --build
# Check: docker-compose logs -f
```

### Debugging
```bash
docker-compose logs --tail=50 -f  # View last 50 lines, follow
docker-compose exec cpp-web-app sh # Interactive shell
```

### Rebuild Everything
```bash
docker-compose down -v
docker-compose build --no-cache
docker-compose up
```

---

## Docker Compose Files

| File | Purpose |
|------|---------|
| docker-compose.yml | Standard (app only) |
| docker-compose.full.yml | With monitoring, proxy, logging |

### Run Extended Version
```bash
# With Nginx reverse proxy
docker-compose -f docker-compose.full.yml --profile with-nginx up

# With monitoring (Prometheus + Grafana)
docker-compose -f docker-compose.full.yml --profile with-monitoring up

# With logging (Elasticsearch + Kibana)
docker-compose -f docker-compose.full.yml --profile with-logging up
```

---

## Troubleshooting

### "Cannot connect to Docker daemon"
```bash
# Start Docker (Windows/Mac: Open Docker Desktop)
# Linux: sudo systemctl start docker
```

### "Port 8080 already in use"
```bash
# Option 1: Use different port in docker-compose.yml
ports:
  - "8081:8080"

# Option 2: Kill process using port
# Windows: netstat -ano | findstr :8080 → taskkill /PID <PID> /F
# Linux: lsof -i :8080 → kill -9 <PID>
```

### "Build failed"
```bash
# Rebuild with no cache
docker-compose build --no-cache

# View detailed output
docker-compose up --build
```

### "Container exits immediately"
```bash
# Check logs
docker-compose logs

# Check exit code
docker-compose ps

# Rebuild and run again
docker-compose down
docker-compose up --build
```

---

## Performance

### Check Image Size
```bash
docker images
# Look for cpp-embedded-web-app size
```

Expected: ~300 MB (multistage build optimized)

### Monitor Resource Usage
```bash
docker stats
# Shows CPU, memory, network usage in real-time
```

### Set Resource Limits
In docker-compose.yml:
```yaml
deploy:
  resources:
    limits:
      cpus: '0.5'      # 50% of one CPU
      memory: 256M     # 256 MB max
```

---

## Deployment

### Local Testing
```bash
docker-compose up
```

### Production (AWS)
```bash
docker tag cpp-embedded-web-app:latest 123456.dkr.ecr.us-east-1.amazonaws.com/app:latest
aws ecr get-login-password | docker login --username AWS --password-stdin 123456.dkr.ecr.us-east-1.amazonaws.com
docker push 123456.dkr.ecr.us-east-1.amazonaws.com/app:latest
```

### Production (Docker Hub)
```bash
docker login
docker tag cpp-embedded-web-app:latest username/app:latest
docker push username/app:latest
```

### Production (Kubernetes)
```bash
kubectl create deployment cpp-web-app --image=username/app:latest
kubectl expose deployment cpp-web-app --type=LoadBalancer --port=80 --target-port=8080
```

---

## Health Check

App is healthy when:
```bash
curl http://localhost:8080
# Should return HTML
```

Docker monitors this automatically:
```bash
docker-compose ps
# STATUS shows "Up X minutes" if healthy
# Shows "Up X minutes (unhealthy)" if failing
```

---

## Testing Inside Container

```bash
# Interactive shell
docker-compose exec cpp-web-app sh

# Inside container:
curl http://localhost:8080/api/message
# Should return: {"message":"Hello from C++"}

# Exit: exit or Ctrl+D
```

---

## Useful Aliases

Add to your shell profile (~/.bashrc or ~/.zshrc):

```bash
alias dcup='docker-compose up --build'
alias dcdown='docker-compose down'
alias dclogs='docker-compose logs -f'
alias dcps='docker-compose ps'
alias dcexec='docker-compose exec'
```

Then use:
```bash
dcup        # Instead of docker-compose up --build
dclogs      # Instead of docker-compose logs -f
```

---

## Resources

- [Docker Docs](https://docs.docker.com/)
- [Docker Compose Docs](https://docs.docker.com/compose/)
- [Docker Hub](https://hub.docker.com/)

---

**Quick Links:**
- Getting started: docker-compose up --build
- View logs: docker-compose logs -f
- Stop: docker-compose stop
- Remove: docker-compose down
