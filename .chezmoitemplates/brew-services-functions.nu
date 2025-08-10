# Brew Services Management Functions for Nushell
# Generated from chezmoi template

{{- if eq .chezmoi.os "darwin" }}

# Main brew services command function
export def bs [command: string = "status"] {
    # Check if brew is available
    if not (which brew | is-not-empty) {
        print "❌ Homebrew not found"
        return
    }
    
    match $command {
        "start" => {
            _bs_start_services
        },
        "stop" => {
            _bs_stop_services
        },
        "restart" | "refresh" => {
            _bs_restart_services
        },
        "status" => {
            _bs_show_status
        },
        "list" => {
            _bs_list_all
        },
        _ => {
            print "Usage: bs [start|stop|restart|refresh|status|list]"
            print "  start    - Start configured services"
            print "  stop     - Stop all running services"
            print "  restart  - Restart configured services (alias: refresh)"
            print "  status   - Show service status (default)"
            print "  list     - List all available services"
        }
    }
}

# Helper functions
def _bs_show_status [] {
    print "📊 Brew services status:"
    brew services list | grep -E "(started|stopped|error)"
}

def _bs_list_all [] {
    print "📋 All brew services:"
    brew services list
}

def _bs_start_services [] {
    print -n "▶️  Starting configured services..."
    _manage_brew_services "start" out> /dev/null err> /dev/null
    print " ✅"
}

def _bs_stop_services [] {
    print -n "⏹️  Stopping all services..."
    _manage_brew_services "stop" out> /dev/null err> /dev/null
    print " ✅"
}

def _bs_restart_services [] {
    print -n "🔄 Restarting configured services..."
    _manage_brew_services "restart" out> /dev/null err> /dev/null
    print " ✅"
}

# Core brew services management function
def _manage_brew_services [mode: string = "status"] {
    # Get currently running services
    let running_services = try {
        brew services list --json | from json | where status == "started" | get name
    } catch {
        brew services list | lines | where ($it | str contains "started") | each { |line| $line | split row " " | get 0 }
    }
    
{{- range .services }}
{{- $service := . }}
{{- $excluded := false }}
{{- range $.excluded_services }}
{{- if eq . $service.name }}{{ $excluded = true }}{{ end }}
{{- end }}
{{- if not $excluded }}
    
    # Process {{ .name }}
    let {{ .name }}_running = ("{{ .name }}" in $running_services)
    
    match $mode {
        "start" => {
{{- if hasKey . "active" }}
{{- if .active }}
            # Start {{ .name }} if not running
            if not ${{ .name }}_running {
                try {
                    brew services start "{{ .name }}" out> /dev/null err> /dev/null
                } catch {
                    # Silent failure
                }
            }
{{- end }}
{{- else }}
            # Default to start if active not specified
            if not ${{ .name }}_running {
                try {
                    brew services start "{{ .name }}" out> /dev/null err> /dev/null
                } catch {
                    # Silent failure
                }
            }
{{- end }}
        },
        "stop" => {
            # Stop {{ .name }} if running
            if ${{ .name }}_running {
                try {
                    brew services stop "{{ .name }}" out> /dev/null err> /dev/null
                } catch {
                    # Silent failure
                }
            }
        },
        "restart" => {
{{- if hasKey . "active" }}
{{- if .active }}
            # Restart {{ .name }}
            try {
                brew services restart "{{ .name }}" out> /dev/null err> /dev/null
            } catch {
                # Silent failure
            }
{{- end }}
{{- else }}
            # Default to restart if active not specified
            try {
                brew services restart "{{ .name }}" out> /dev/null err> /dev/null
            } catch {
                # Silent failure
            }
{{- end }}
        }
    }
{{- end }}
{{- end }}
}

# Legacy function aliases for backward compatibility
export def bsvc [mode: string = "restart"] { bs $mode }
export def "bsvc status" [] { bs status }
export def "bsvc start" [] { bs start }
export def "bsvc stop" [] { bs stop }
export def "bsvc restart" [] { bs restart }

{{- end }}