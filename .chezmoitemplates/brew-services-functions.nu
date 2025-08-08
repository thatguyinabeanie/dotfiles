# Brew Services Management Functions for Nushell
# Generated from chezmoi template

{{- if eq .chezmoi.os "darwin" }}

# Core brew services management function
def _manage_brew_services [mode: string = "all"] {
    # Check if brew is available
    if not (which brew | is-not-empty) {
        print "❌ Homebrew not found"
        return
    }
    
    # Get currently running services
    let running_services = (brew services list --json | from json | where status == "started" | get name)
    
    match $mode {
        "status" => {
            print "📊 Brew services status:"
            brew services list | grep -E "(started|stopped|error)" | head -10
            return
        },
        "all" => {
            print "🔧 Managing brew services..."
        }
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
        "all" | "manage" => {
{{- if hasKey . "enable" }}
{{- if eq .enable "false" }}
            # Stop disabled service if running
            if ${{ .name }}_running {
                try {
                    brew services stop "{{ .name }}" out> /dev/null err> /dev/null
                    print "⏹️  Stopped {{ .name }}"
                } catch {
                    # Silent failure
                }
            }
{{- else if eq .enable "ifInstalled" }}
            # Only manage if installed
            if (which {{ .name }} | is-not-empty) {
{{- if eq .action "restart" }}
                try {
                    brew services restart "{{ .name }}" out> /dev/null err> /dev/null
                    print "🔄 Restarted {{ .name }}"
                } catch {
                    # Silent failure
                }
{{- else if eq .action "start" }}
                if not ${{ .name }}_running {
                    try {
                        brew services start "{{ .name }}" out> /dev/null err> /dev/null
                        print "▶️  Started {{ .name }}"
                    } catch {
                        # Silent failure
                    }
                }
{{- end }}
            }
{{- else }}
            # Service enabled (true or other truthy value)
{{- if eq .action "restart" }}
            try {
                brew services restart "{{ .name }}" out> /dev/null err> /dev/null
                print "🔄 Restarted {{ .name }}"
            } catch {
                # Silent failure
            }
{{- else if eq .action "start" }}
            if not ${{ .name }}_running {
                try {
                    brew services start "{{ .name }}" out> /dev/null err> /dev/null
                    print "▶️  Started {{ .name }}"
                } catch {
                    # Silent failure
                }
            }
{{- end }}
{{- end }}
{{- else }}
            # Default behavior when enable is not specified (assumed true)
{{- if eq .action "restart" }}
            try {
                brew services restart "{{ .name }}" out> /dev/null err> /dev/null
                print "🔄 Restarted {{ .name }}"
            } catch {
                # Silent failure
            }
{{- else if eq .action "start" }}
            if not ${{ .name }}_running {
                try {
                    brew services start "{{ .name }}" out> /dev/null err> /dev/null
                    print "▶️  Started {{ .name }}"
                } catch {
                    # Silent failure
                }
            }
{{- end }}
{{- end }}
        },
        "start" => {
{{- if hasKey . "enable" }}
{{- if ne .enable "false" }}
{{- if eq .enable "ifInstalled" }}
            # Only start if installed
            if (which {{ .name }} | is-not-empty) and (not ${{ .name }}_running) {
                try {
                    brew services start "{{ .name }}" out> /dev/null err> /dev/null
                    print "▶️  Started {{ .name }}"
                } catch {
                    # Silent failure
                }
            }
{{- else }}
            # Service enabled, start if not running
            if not ${{ .name }}_running {
                try {
                    brew services start "{{ .name }}" out> /dev/null err> /dev/null
                    print "▶️  Started {{ .name }}"
                } catch {
                    # Silent failure
                }
            }
{{- end }}
{{- end }}
{{- else }}
            # Default behavior when enable is not specified (assumed true)
            if not ${{ .name }}_running {
                try {
                    brew services start "{{ .name }}" out> /dev/null err> /dev/null
                    print "▶️  Started {{ .name }}"
                } catch {
                    # Silent failure
                }
            }
{{- end }}
        },
        "stop" => {
            if ${{ .name }}_running {
                try {
                    brew services stop "{{ .name }}" out> /dev/null err> /dev/null
                    print "⏹️  Stopped {{ .name }}"
                } catch {
                    # Silent failure
                }
            }
        },
        "restart" => {
{{- if hasKey . "enable" }}
{{- if ne .enable "false" }}
{{- if eq .enable "ifInstalled" }}
            # Only restart if installed
            if (which {{ .name }} | is-not-empty) {
                try {
                    brew services restart "{{ .name }}" out> /dev/null err> /dev/null
                    print "🔄 Restarted {{ .name }}"
                } catch {
                    # Silent failure
                }
            }
{{- else }}
            # Service enabled, restart
            try {
                brew services restart "{{ .name }}" out> /dev/null err> /dev/null
                print "🔄 Restarted {{ .name }}"
            } catch {
                # Silent failure
            }
{{- end }}
{{- end }}
{{- else }}
            # Default behavior when enable is not specified (assumed true)
            try {
                brew services restart "{{ .name }}" out> /dev/null err> /dev/null
                print "🔄 Restarted {{ .name }}"
            } catch {
                # Silent failure
            }
{{- end }}
        }
    }
{{- end }}
{{- end }}
    
    if $mode in ["all", "manage"] {
        print ""
        print "📊 Final brew services status:"
        brew services list | grep -E "(started|stopped|error)" | head -10
    }
}

# Main brew services commands
export def bsvc [mode: string = "all"] { _manage_brew_services $mode }
export def "bsvc status" [] { _manage_brew_services "status" }
export def "bsvc start" [] { _manage_brew_services "start" }
export def "bsvc stop" [] { _manage_brew_services "stop" }
export def "bsvc restart" [] { _manage_brew_services "restart" }

# Individual service control commands
{{- range .services }}
{{- $service := . }}
{{- $excluded := false }}
{{- range $.excluded_services }}
{{- if eq . $service.name }}{{ $excluded = true }}{{ end }}
{{- end }}
{{- if not $excluded }}
export def "{{ .name }} start" [] { brew services start {{ .name }} }
export def "{{ .name }} stop" [] { brew services stop {{ .name }} }
export def "{{ .name }} restart" [] { brew services restart {{ .name }} }
{{- end }}
{{- end }}

# Quick service status check commands
export def "bsvc running" [] {
    brew services list --json | from json | where status == "started" | get name | sort
}

export def "bsvc stopped" [] {
    brew services list --json | from json | where status == "stopped" | get name | sort
}

{{- end }}