# Brew Services Management Functions
# Generated from chezmoi template

{{- if eq .chezmoi.os "darwin" }}

# Core brew services management function
_manage_brew_services() {
    local mode="${1:-all}"  # all, start, stop, restart, status
    
    # Check if brew is available
    if ! command -v brew &> /dev/null; then
        echo "❌ Homebrew not found"
        return 1
    fi
    
    # Get currently running services
    local running_services=$(brew services list --json | jq -r '.[] | select(.status == "started") | .name')
    
    case "$mode" in
        "status")
            echo "📊 Brew services status:"
            brew services list | grep -E "(started|stopped|error)" | head -10
            return 0
            ;;
        "all")
            echo "🔧 Managing brew services..."
            ;;
    esac
    
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
        "all"|"manage")
{{- if hasKey . "enable" }}
{{- if eq .enable "false" }}
            # Stop disabled service if running
            if ${{ .name }}_running; then
                brew services stop "{{ .name }}" >/dev/null 2>&1 && echo "⏹️  Stopped {{ .name }}"
            fi
{{- else if eq .enable "ifInstalled" }}
            # Only manage if installed
            if command -v "{{ .name }}" >/dev/null 2>&1; then
{{- if eq .action "restart" }}
                # Restart {{ .name }}
                brew services restart "{{ .name }}" >/dev/null 2>&1 && echo "🔄 Restarted {{ .name }}"
{{- else if eq .action "start" }}
                # Start {{ .name }} if not running
                if ! ${{ .name }}_running; then
                    brew services start "{{ .name }}" >/dev/null 2>&1 && echo "▶️  Started {{ .name }}"
                fi
{{- end }}
            fi
{{- else }}
            # Service enabled (true or other truthy value)
{{- if eq .action "restart" }}
            # Restart {{ .name }}
            brew services restart "{{ .name }}" >/dev/null 2>&1 && echo "🔄 Restarted {{ .name }}"
{{- else if eq .action "start" }}
            # Start {{ .name }} if not running
            if ! ${{ .name }}_running; then
                brew services start "{{ .name }}" >/dev/null 2>&1 && echo "▶️  Started {{ .name }}"
            fi
{{- end }}
{{- end }}
{{- else }}
            # Default behavior when enable is not specified (assumed true)
{{- if eq .action "restart" }}
            # Restart {{ .name }}
            brew services restart "{{ .name }}" >/dev/null 2>&1 && echo "🔄 Restarted {{ .name }}"
{{- else if eq .action "start" }}
            # Start {{ .name }} if not running
            if ! ${{ .name }}_running; then
                brew services start "{{ .name }}" >/dev/null 2>&1 && echo "▶️  Started {{ .name }}"
            fi
{{- end }}
{{- end }}
            ;;
        "start")
{{- if hasKey . "enable" }}
{{- if ne .enable "false" }}
{{- if eq .enable "ifInstalled" }}
            # Only start if installed
            if command -v "{{ .name }}" >/dev/null 2>&1 && ! ${{ .name }}_running; then
                brew services start "{{ .name }}" >/dev/null 2>&1 && echo "▶️  Started {{ .name }}"
            fi
{{- else }}
            # Service enabled, start if not running
            if ! ${{ .name }}_running; then
                brew services start "{{ .name }}" >/dev/null 2>&1 && echo "▶️  Started {{ .name }}"
            fi
{{- end }}
{{- end }}
{{- else }}
            # Default behavior when enable is not specified (assumed true)
            if ! ${{ .name }}_running; then
                brew services start "{{ .name }}" >/dev/null 2>&1 && echo "▶️  Started {{ .name }}"
            fi
{{- end }}
            ;;
        "stop")
            if ${{ .name }}_running; then
                brew services stop "{{ .name }}" >/dev/null 2>&1 && echo "⏹️  Stopped {{ .name }}"
            fi
            ;;
        "restart")
{{- if hasKey . "enable" }}
{{- if ne .enable "false" }}
{{- if eq .enable "ifInstalled" }}
            # Only restart if installed
            if command -v "{{ .name }}" >/dev/null 2>&1; then
                brew services restart "{{ .name }}" >/dev/null 2>&1 && echo "🔄 Restarted {{ .name }}"
            fi
{{- else }}
            # Service enabled, restart
            brew services restart "{{ .name }}" >/dev/null 2>&1 && echo "🔄 Restarted {{ .name }}"
{{- end }}
{{- end }}
{{- else }}
            # Default behavior when enable is not specified (assumed true)
            brew services restart "{{ .name }}" >/dev/null 2>&1 && echo "🔄 Restarted {{ .name }}"
{{- end }}
            ;;
    esac
{{- end }}
{{- end }}
    
    if [[ "$mode" == "all" || "$mode" == "manage" ]]; then
        echo ""
        echo "📊 Final brew services status:"
        brew services list | grep -E "(started|stopped|error)" | head -10
    fi
}

# Convenient functions
function bsvc() { _manage_brew_services "$@"; }
function bsvc_status() { _manage_brew_services status; }
function bsvc_start() { _manage_brew_services start; }
function bsvc_stop() { _manage_brew_services stop; }
function bsvc_restart() { _manage_brew_services restart; }

# Individual service control functions
{{- range .services }}
{{- $service := . }}
{{- $excluded := false }}
{{- range $.excluded_services }}
{{- if eq . $service.name }}{{ $excluded = true }}{{ end }}
{{- end }}
{{- if not $excluded }}
function {{ .name }}_start() { brew services start {{ .name }}; }
function {{ .name }}_stop() { brew services stop {{ .name }}; }
function {{ .name }}_restart() { brew services restart {{ .name }}; }
{{- end }}
{{- end }}

# Quick service status check functions
function bsvc_running() {
    brew services list --json | jq -r '.[] | select(.status == "started") | .name' | sort
}

function bsvc_stopped() {
    brew services list --json | jq -r '.[] | select(.status == "stopped") | .name' | sort
}

{{- end }}