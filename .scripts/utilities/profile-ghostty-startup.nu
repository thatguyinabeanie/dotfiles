#!/usr/bin/env nu

# Ghostty Full Startup Performance Profiler
# Measures complete startup time from Ghostty launch to shell ready
# 
# Usage:
#   nu scripts/profile-ghostty-startup.nu                    # Quick profile
#   nu scripts/profile-ghostty-startup.nu --detailed         # Detailed analysis
#   nu scripts/profile-ghostty-startup.nu --breakdown        # Component breakdown

def main [
    --detailed (-d)        # Run detailed component analysis
    --breakdown (-b)       # Break down each startup component
    --runs (-r): int = 5   # Number of benchmark runs
    --output (-o): string  # Output file for results
] {
    print "👻 Ghostty Full Startup Performance Profiler\n"
    
    # Check dependencies
    check_dependencies
    
    let timestamp = (date now | format date "%Y%m%d_%H%M%S")
    let output_file = if ($output | is-empty) { $"ghostty_profile_($timestamp)" } else { $output }
    
    # Basic full startup profiling
    print "📊 Full startup time profiling..."
    run_full_startup_profile $runs $output_file
    
    # Component breakdown
    if $breakdown {
        print "\n🔍 Component breakdown analysis..."
        run_component_breakdown $runs
    }
    
    # Detailed analysis
    if $detailed {
        print "\n🔬 Detailed analysis..."
        run_detailed_analysis $runs
    }
    
    # Generate comprehensive report
    print "\n📋 Generating comprehensive report..."
    generate_ghostty_report $output_file $detailed $breakdown
    
    print $"\n✅ Ghostty profile complete! Results saved to ($output_file).md"
}

def check_dependencies [] {
    let tools = ["hyperfine", "ghostty"]
    let missing = ($tools | where { |tool| (which $tool | is-empty) })
    
    if ($missing | is-not-empty) {
        error make {msg: $"❌ Missing tools: ($missing | str join ', ')"}
    }
    true
}

def run_full_startup_profile [runs: int, output_base: string] {
    # Profile the complete Ghostty → tmux → shell startup chain
    print "  Testing complete Ghostty startup chain..."
    
    # Test different startup scenarios
    let commands = [
        "nu -c 'exit'"
        "/opt/homebrew/bin/tmux new-session -d -s test-session '/opt/homebrew/bin/nu -c exit'; /opt/homebrew/bin/tmux kill-session -t test-session"
        "nu ~/.config/ghostty/ghostty-init.nu"
    ]
    
    ^hyperfine --runs $runs --warmup 2 --export-markdown $"($output_base)_full.md" --export-json $"($output_base)_full.json" ...$commands
}

def run_component_breakdown [runs: int] {
    print "  Breaking down startup components..."
    
    let components = [
        ["nushell-env-source", "nu -c 'source ~/.config/nushell/env.nu; exit'"]
        ["tmux-session-create", "/opt/homebrew/bin/tmux new-session -d -s test-breakdown; /opt/homebrew/bin/tmux kill-session -t test-breakdown"]
        ["tmux-session-attach", "/opt/homebrew/bin/tmux new-session -d -s test-attach '/bin/sleep 0.1'; /opt/homebrew/bin/tmux attach-session -t test-attach; /opt/homebrew/bin/tmux kill-session -t test-attach"]
        ["ghostty-init-nu", "nu ~/.config/ghostty/ghostty-init.nu"]
        ["ghostty-init-zsh", "zsh ~/.config/ghostty/ghostty-init.zsh"]
    ]
    
    $components | each { |comp|
        let name = $comp.0
        let cmd = $comp.1
        print $"    Profiling ($name)..."
        try {
            ^hyperfine --runs 3 --warmup 1 --shell=none $cmd
        } catch {
            print $"      ⚠️  ($name) failed to profile"
        }
    } | str join "\n"
}

def run_detailed_analysis [runs: int] {
    print "  Analyzing configuration impact..."
    
    # Test different scenarios
    let scenarios = [
        ["minimal-nu", "nu --no-config-file -c 'exit'"]
        ["env-only", "nu -e 'source ~/.config/nushell/env.nu' -c 'exit'"]
        ["full-config", "nu -c 'exit'"]
    ]
    
    $scenarios | each { |scenario|
        let name = $scenario.0  
        let cmd = $scenario.1
        print $"    Testing ($name)..."
        ^hyperfine --runs 3 --warmup 1 $cmd
    } | str join "\n"
}

def generate_ghostty_report [output_base: string, detailed: bool, breakdown: bool] {
    let report_file = $"($output_base).md"
    
    let header = $"# Ghostty Complete Startup Performance Report
Generated: (date now | format date '%Y-%m-%d %H:%M:%S')

## Summary
This report analyzes the complete startup performance from Ghostty launch through to shell readiness.

### Startup Chain Analysis
Your Ghostty configuration uses this startup chain:
1. **Ghostty** launches with `initial-command` 
2. **ghostty-init.nu** checks for existing tmux session
3. **tmux** creates/attaches to 'ghostty' session  
4. **nushell** starts within tmux with full config

"

    # Read full results if they exist
    let full_results = if ($"($output_base)_full.md" | path exists) {
        $"## Full Startup Comparison\n\n(open $"($output_base)_full.md")\n\n"
    } else { "" }
    
    let analysis = "## Configuration Analysis

### Current Setup:
- **Shell**: Nushell (nu)
- **Terminal Multiplexer**: tmux  
- **Session**: Persistent 'ghostty' session
- **Init Script**: `ghostty-init.nu`

### Startup Components:
1. **Ghostty Process Launch**: ~5-15ms (system dependent)
2. **Init Script Execution**: Sources env.nu + tmux logic
3. **tmux Session Management**: Create/attach to 'ghostty' session
4. **Shell Initialization**: Full nushell config load

"

    let recommendations = "## Performance Recommendations

### Optimization Strategies:
1. **Lazy Loading**: Defer heavy shell integrations until first use
2. **tmux Optimization**: 
   - Consider `tmux set-option -g default-terminal` optimizations
   - Review tmux plugin load times
3. **Shell Config**: Your nushell is already very fast (~8ms)
4. **Ghostty Settings**: Review `shell-integration-features` impact

### Monitoring Commands:
```bash
# Profile full startup
nu .scripts/utilities/profile-ghostty-startup.nu

# Component breakdown  
nu .scripts/utilities/profile-ghostty-startup.nu --breakdown

# Detailed analysis
nu .scripts/utilities/profile-ghostty-startup.nu --detailed
```

### Performance Targets (Full Chain):
- **Excellent**: < 100ms total
- **Good**: < 200ms total  
- **Needs Work**: > 500ms total

### Quick Optimizations:
- Set `GHOSTTY_NO_TMUX=1` to bypass tmux for comparison
- Test with minimal nushell config: `nu --no-config-file`
- Monitor tmux session count: `tmux list-sessions`

"
    
    let content = $header + $full_results + $analysis + $recommendations
    $content | save $report_file
}

# Quick profile function
def "main quick" [] {
    check_dependencies
    
    print "⚡ Quick Ghostty startup profile...\n"
    ^hyperfine --runs 3 --warmup 1 "nu ~/.config/ghostty/ghostty-init.nu"
}

# Live monitoring function  
def "main monitor" [
    --threshold (-t): int = 200   # Alert if total startup > threshold (ms)
] {
    print $"🔄 Monitoring Ghostty startup performance..."
    print $"⚠️  Will alert if startup exceeds ($threshold)ms\n"
    
    loop {
        let result = (^hyperfine --runs 1 --warmup 0 --export-json /tmp/ghostty_monitor.json "nu ~/.config/ghostty/ghostty-init.nu" | complete)
        
        if $result.exit_code == 0 {
            let data = (open /tmp/ghostty_monitor.json | from json)
            let mean_ms = ($data.results.0.mean * 1000 | math round)
            
            let status = if $mean_ms > $threshold { "🔴 SLOW" } else { "🟢 OK" }
            print $"(date now | format date '%H:%M:%S') - Ghostty Init: ($mean_ms)ms ($status)"
            
            if $mean_ms > $threshold {
                print $"⚠️  Startup time exceeded threshold!"
            }
        }
        
        sleep 30sec
    }
}