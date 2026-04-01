# Docker & Lazydocker

**Container platform**—run, manage, and orchestrate containers.

## 🐚 Shell Aliases—Compose

| Alias | Command |
|-------|---------|
| `d` | `docker` |
| `dc` | `docker compose` |
| `dcu` | `docker compose up` |
| `dcud` | `docker compose up -d` |
| `dcd` | `docker compose down` |
| `dcb` | `docker compose build` |
| `dcl` | `docker compose logs` |
| `dclf` | `docker compose logs -f` |
| `dce` | `docker compose exec` |
| `dcr` | `docker compose restart` |
| `dcps` | `docker compose ps` |

## 🐚 Shell Aliases—Containers

| Alias | Command |
|-------|---------|
| `dps` | `docker ps` |
| `dpsa` | `docker ps -a` |
| `dr` | `docker run` |
| `drit` | `docker run -it` |
| `drm` | `docker rm` |
| `drmf` | `docker rm -f` |
| `dst` | `docker start` |
| `dstp` | `docker stop` |
| `drs` | `docker restart` |
| `dex` | `docker exec` |
| `deit` | `docker exec -it` |
| `dlo` | `docker logs` |
| `dlof` | `docker logs -f` |
| `dins` | `docker inspect` |
| `dsts` | `docker stats` |

## 🐚 Shell Aliases—Images, Volumes, Networks, System

| Alias | Command |
|-------|---------|
| `di` | `docker images` |
| `dpl` | `docker pull` |
| `dph` | `docker push` |
| `drmi` | `docker rmi` |
| `dtag` | `docker tag` |
| `dbld` | `docker build` |
| `dipr` | `docker image prune -a` |
| `dvls` | `docker volume ls` |
| `dvrm` | `docker volume rm` |
| `dvpr` | `docker volume prune` |
| `dnls` | `docker network ls` |
| `dnc` | `docker network create` |
| `dnrm` | `docker network rm` |
| `dsp` | `docker system prune` |
| `dspa` | `docker system prune --all --volumes` |

## 🖥️ Lazydocker—Global Navigation

Launch with: `lazydocker`

| Key | Action |
|-----|--------|
| `h` / `l` or `←` / `→` | Switch between panels |
| `j` / `k` or `↑` / `↓` | Navigate list |
| `[` / `]` | Switch tabs within panel |
| `q` | Quit |
| `?` | Open help / keybindings |
| `/` | Filter list |
| `x` | Open command menu |

## 🐋 Lazydocker—Containers Panel

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
| `p` | Pause / unpause |
| `a` | Attach to container |

## 🖼️ Lazydocker—Images / Volumes / Networks

| Panel | Key | Action |
|-------|-----|--------|
| Images | `d` | Remove image |
| Images | `p` | Pull latest version |
| Images | `u` | Push image |
| Volumes | `d` | Remove volume |
| Volumes | `Enter` | Browse volume contents |
| Networks | `d` | Remove network |

## 📜 Lazydocker—Logs View

| Key | Action |
|-----|--------|
| `f` | Toggle follow mode |
| `c` | Copy log to clipboard |
| `w` | Toggle wrap |
| `/` | Search in logs |
| `Esc` | Return to list |
