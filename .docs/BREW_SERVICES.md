# Brew Services Management

This system provides convenient functions for managing Homebrew services, with initial setup handled automatically.

## Initial Setup

Services are configured during the initial dotfiles setup via a `run_once` script. After that, you can manage services using shell functions.

## Configuration

Services are configured in `.chezmoidata/packages/macos/services.yaml`:

```yaml
services:
  - name: "service-name"
    description: "Human readable description"
    action: "start" # or "restart"
```

## Shell Functions

### Zsh Functions

```bash
# Manage all services
bsvc

# Check service status
bsvc_status

# Start all enabled services
bsvc_start

# Stop all services
bsvc_stop

# Restart all enabled services
bsvc_restart

# Individual service controls (auto-generated for each service)


# Quick status checks
bsvc_running    # List running services
bsvc_stopped    # List stopped services
```

### Nushell Commands

```nu
# Manage all services
bsvc

# Check service status
bsvc status

# Start/stop/restart all services
bsvc start
bsvc stop
bsvc restart

# Individual service controls


# Quick status checks
bsvc running    # List running services
bsvc stopped    # List stopped services
```

## Actions

- **`start`**: Only start the service if it's not already running
- **`restart`**: Always restart the service (stops then starts)

## Excluding Services

Add services to the `excluded_services` list to prevent automatic management:

```yaml
excluded_services:
  - "docker" # Managed manually
```

## Adding New Services

1. Install the service via Homebrew
2. Add it to `.chezmoidata/packages/macos/services.yaml`
3. Use `bsvc` command to manage the new service

## Manual Service Management

```bash
# List all services
brew services list

# Start a service
brew services start <service-name>

# Stop a service
brew services stop <service-name>

# Restart a service
brew services restart <service-name>
```

## Current Configuration

The system currently manages:


- **borders**: Window borders for macOS (start)
- **redis**: Redis in-memory data store (start)

Uncomment additional services in the configuration file as needed.
