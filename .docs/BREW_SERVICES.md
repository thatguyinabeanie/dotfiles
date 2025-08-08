# Brew Services Management

This system automatically manages Homebrew services every time you run `chezmoi apply`.

## Configuration

Services are configured in `.chezmoidata/brew-services.yaml`:

```yaml
services:
  - name: "service-name"
    description: "Human readable description"
    action: "start"    # or "restart"
```

## Actions

- **`start`**: Only start the service if it's not already running
- **`restart`**: Always restart the service (stops then starts)

## Excluding Services

Add services to the `excluded_services` list to prevent automatic management:

```yaml
excluded_services:
  - "docker"  # Managed manually
```

## Adding New Services

1. Install the service via Homebrew
2. Add it to `.chezmoidata/brew-services.yaml`
3. Run `chezmoi apply`

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
- **sketchybar**: Custom macOS menu bar (restart)
- **borders**: Window borders for macOS (start)
- **redis**: Redis in-memory data store (start)

Uncomment additional services in the configuration file as needed.