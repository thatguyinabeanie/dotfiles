# 🐳 Docker & Lazydocker Cheat Sheet

> Press `q` to close · `j/k` to scroll · `/` to search

---

## 🐚 Shell Aliases (Quick Reference)

| Alias | Command | Description |
|-------|---------|-------------|
| `d` | `docker` | Base command |
| **Compose** | | |
| `dc` | `docker compose` | Base compose |
| `dcu` | `docker compose up` | Start services |
| `dcud` | `docker compose up -d` | Start detached |
| `dcd` | `docker compose down` | Stop & remove containers |
| `dcb` | `docker compose build` | Build images |
| `dcl` | `docker compose logs` | View logs |
| `dclf` | `docker compose logs -f` | Follow logs |
| `dce` | `docker compose exec` | Exec into service |
| `dcr` | `docker compose restart` | Restart services |
| `dcps` | `docker compose ps` | List running services |
| **Containers** | | |
| `dps` | `docker ps` | List running containers |
| `dpsa` | `docker ps -a` | List all containers |
| `dr` | `docker run` | Run container |
| `drit` | `docker run -it` | Run interactive |
| `drm` | `docker rm` | Remove container |
| `drmf` | `docker rm -f` | Force remove |
| `dst` | `docker start` | Start container |
| `dstp` | `docker stop` | Stop container |
| `drs` | `docker restart` | Restart container |
| `dex` | `docker exec` | Exec in running container |
| `deit` | `docker exec -it` | Interactive exec |
| `dlo` | `docker logs` | Container logs |
| `dlof` | `docker logs -f` | Follow container logs |
| `dins` | `docker inspect` | Inspect container |
| `dsts` | `docker stats` | Live resource stats |
| **Images** | | |
| `di` | `docker images` | List images |
| `dpl` | `docker pull` | Pull image |
| `dph` | `docker push` | Push image |
| `drmi` | `docker rmi` | Remove image |
| `dtag` | `docker tag` | Tag image |
| `dbld` | `docker build` | Build image |
| `dipr` | `docker image prune -a` | Prune unused images |
| **Volumes** | | |
| `dvls` | `docker volume ls` | List volumes |
| `dvrm` | `docker volume rm` | Remove volume |
| `dvpr` | `docker volume prune` | Prune unused volumes |
| **Networks** | | |
| `dnls` | `docker network ls` | List networks |
| `dnc` | `docker network create` | Create network |
| `dnrm` | `docker network rm` | Remove network |
| **System** | | |
| `dsp` | `docker system prune` | Clean stopped containers + dangling images |
| `dspa` | `docker system prune --all --volumes` | Full nuclear clean |

---

## 🖥️ Lazydocker TUI

> Launch with: `lazydocker` · Opens a full TUI dashboard

### Global Navigation

| Key | Action |
|-----|--------|
| `h` / `l` or `←` / `→` | Switch between panels |
| `j` / `k` or `↑` / `↓` | Navigate list |
| `[` / `]` | Switch between tabs within a panel |
| `q` | Quit lazydocker |
| `?` | Open help / keybindings |
| `/` | Filter list |
| `x` | Open command menu |

### 🐋 Containers Panel

| Key | Action |
|-----|--------|
| `Enter` | Focus container logs |
| `s` | Stop container |
| `r` | Restart container |
| `d` | Remove container |
| `e` | Exec shell in container |
| `b` | Open bash in container |
| `l` | View logs |
| `m` | View mounts |
| `c` | View container config |
| `p` | Pause / Unpause |
| `a` | Attach to container |

### 🖼️ Images Panel

| Key | Action |
|-----|--------|
| `d` | Remove image |
| `p` | Pull latest version |
| `u` | Push image |
| `Enter` | View image details |

### 📦 Volumes Panel

| Key | Action |
|-----|--------|
| `d` | Remove volume |
| `Enter` | Browse volume contents |

### 🌐 Networks Panel

| Key | Action |
|-----|--------|
| `d` | Remove network |
| `Enter` | View network details |

### 📜 Logs View

| Key | Action |
|-----|--------|
| `f` | Toggle follow mode |
| `c` | Copy log to clipboard |
| `w` | Toggle wrap |
| `/` | Search in logs |
| `Esc` | Return to list |

---

## 🧹 Common Cleanup Workflows

```bash
# Stop all running containers
docker stop $(docker ps -q)

# Remove all stopped containers
docker rm $(docker ps -aq)

# Remove all unused images
docker image prune -a

# Remove unused volumes
docker volume prune

# Nuclear option: remove everything unused
docker system prune --all --volumes
# alias: dspa
```

---

## 🔍 Useful One-Liners

```bash
# Follow logs for a specific service
dclf <service>

# Open a shell in a running container
deit <container> sh

# Copy a file from a container
docker cp <container>:/path/to/file ./local-file

# View resource usage
dsts

# Inspect container's IP address
docker inspect <container> | grep IPAddress
```
