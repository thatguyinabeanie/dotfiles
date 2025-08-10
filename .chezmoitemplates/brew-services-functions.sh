# Brew Services Management Functions
# Generated from chezmoi template

{{- if eq .chezmoi.os "darwin" }}

# Main brew services command function
bs() {
    local command="${1:-status}"
    
    # Check if brew is available
    if ! command -v brew &> /dev/null; then
        echo "❌ Homebrew not found"
        return 1
    fi
    
    case "$command" in
        "start")
            _bs_start_services
            ;;
        "stop")
            _bs_stop_services
            ;;
        "restart"|"refresh")
            _bs_restart_services
            ;;
        "status")
            _bs_show_status
            ;;
        "list")
            _bs_list_all
            ;;
        *)
            echo "Usage: bs [start|stop|restart|refresh|status|list]"
            echo "  start    - Start configured services"
            echo "  stop     - Stop all running services"
            echo "  restart  - Restart configured services (alias: refresh)"
            echo "  status   - Show service status (default)"
            echo "  list     - List all available services"
            return 1
            ;;
    esac
}

# Helper functions
_bs_show_status() {
    echo "📊 Brew services status:"
    brew services list | grep -E "(started|stopped|error)"
}

_bs_list_all() {
    echo "📋 All brew services:"
    brew services list
}

_bs_start_services() {
    printf "▶️  Starting configured services..."
    _manage_brew_services "start" >/dev/null 2>&1
    printf " ✅\n"
}

_bs_stop_services() {
    printf "⏹️  Stopping all services..."
    _manage_brew_services "stop" >/dev/null 2>&1
    printf " ✅\n"
}

_bs_restart_services() {
    printf "🔄 Restarting configured services..."
    _manage_brew_services "restart" >/dev/null 2>&1
    printf " ✅\n"
}

# Core brew services management function
_manage_brew_services() {
    local mode="${1:-status}"
    
    # Get currently running services
    local running_services=$(brew services list --json 2>/dev/null | jq -r '.[] | select(.status == "started") | .name' 2>/dev/null || brew services list | grep started | awk '{print $1}')
    
{{- range .services }}
{{- $service := . }}
{{- $excluded := false }}
{{- range $.excluded_services }}
{{- if eq . $service.name }}{{ $excluded = true }}{{ end }}
{{- end }}
{{- if not $excluded }}
    
    # Process {{ .name }}
    if echo "$running_services" | grep -q "^{{ .name }}$"; then
        local {{ .name }}_running=true
    else
        local {{ .name }}_running=false
    fi
    
    case "$mode" in
        "start")
{{- if hasKey . "active" }}
{{- if .active }}
            # Start {{ .name }} if not running
            if ! ${{ .name }}_running; then
                brew services start "{{ .name }}" >/dev/null 2>&1
            fi
{{- end }}
{{- else }}
            # Default to start if active not specified
            if ! ${{ .name }}_running; then
                brew services start "{{ .name }}" >/dev/null 2>&1
            fi
{{- end }}
            ;;
        "stop")
            # Stop {{ .name }} if running
            if ${{ .name }}_running; then
                brew services stop "{{ .name }}" >/dev/null 2>&1
            fi
            ;;
        "restart")
{{- if hasKey . "active" }}
{{- if .active }}
            # Restart {{ .name }}
            brew services restart "{{ .name }}" >/dev/null 2>&1
{{- end }}
{{- else }}
            # Default to restart if active not specified
            brew services restart "{{ .name }}" >/dev/null 2>&1
{{- end }}
            ;;
    esac
{{- end }}
{{- end }}
}

# Legacy function aliases for backward compatibility
function bsvc() { bs restart; }
function bsvc_status() { bs status; }
function bsvc_start() { bs start; }
function bsvc_stop() { bs stop; }
function bsvc_restart() { bs restart; }

{{- end }}