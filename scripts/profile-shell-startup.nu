#!/usr/bin/env nu

# Shell Startup Performance Profiler
# Automated tool for profiling shell startup time and components
# 
# Usage:
#   nu scripts/profile-shell-startup.nu               # Quick profile
#   nu scripts/profile-shell-startup.nu --detailed    # Detailed analysis
#   nu scripts/profile-shell-startup.nu --compare     # Compare optimizations

def main [
    --detailed (-d)     # Run detailed component analysis
    --compare (-c)      # Compare with/without optimizations
    --runs (-r): int = 10  # Number of benchmark runs
    --output (-o): string  # Output file for results
] {
    print "🚀 Shell Startup Performance Profiler\n"
    
    # Check if hyperfine is available
    if (which hyperfine | is-empty) {
        print "❌ hyperfine not found. Install with: mise install hyperfine"
        exit 1
    }
    
    let timestamp = (date now | format date "%Y%m%d_%H%M%S")
    let output_file = if ($output | is-empty) { $"shell_profile_($timestamp)" } else { $output }
    
    # Basic startup profiling
    print "📊 Basic startup time profiling..."
    run_basic_profile $runs $output_file
    
    # Detailed component analysis
    if $detailed {
        print "\n🔍 Detailed component analysis..."
        run_component_analysis $runs
        run_config_breakdown
    }
    
    # Comparison analysis
    if $compare {
        print "\n⚖️  Optimization comparison..."
        run_optimization_comparison $runs
    }
    
    # Generate summary report
    print "\n📋 Generating summary report..."
    generate_summary_report $output_file $detailed $compare
    
    print $"\n✅ Profile complete! Results saved to ($output_file).md"
}

def run_basic_profile [runs: int, output_base: string] {
    # Basic startup comparison
    ^hyperfine --runs $runs --warmup 3 \
        --export-markdown $"($output_base)_basic.md" \
        --export-json $"($output_base)_basic.json" \
        "nu --no-config-file -c 'exit'" \
        "nu -c 'exit'" | str trim
}

def run_component_analysis [runs: int] {
    print "  Analyzing individual components..."
    
    let components = [
        ["zoxide", "nu -c 'zoxide init nushell | ignore'"]
        ["mise", "nu -c 'mise activate nu | ignore'"] 
        ["starship", "nu -c 'starship init nu | ignore'"]
        ["carapace", "nu -c 'carapace _carapace nushell | ignore'"]
    ]
    
    $components | each { |comp|
        let name = $comp.0
        let cmd = $comp.1
        print $"    Profiling ($name)..."
        ^hyperfine --runs 5 --warmup 2 --shell=none $cmd | str trim
    } | str join "\n"
}

def run_config_breakdown [] {
    print "  Analyzing config file sections..."
    
    let config_sections = [
        ["env.nu", "nu -e 'source ~/.config/nushell/env.nu' -c 'exit'"]
        ["aliases.nu", "nu -e 'source ~/.config/nushell/aliases.nu' -c 'exit'"]
        ["theme", "nu -e 'source ~/.config/nushell/.catppuccin/themes/catppuccin_mocha.nu' -c 'exit'"]
    ]
    
    $config_sections | each { |section|
        let name = $section.0
        let cmd = $section.1
        print $"    Testing ($name)..."
        ^hyperfine --runs 3 --warmup 1 $cmd | str trim
    } | str join "\n"
}

def run_optimization_comparison [runs: int] {
    print "  Comparing optimization strategies..."
    
    # Test with different configurations
    let optimizations = [
        ["current", "nu -c 'exit'"]
        ["no-starship", "nu -e '$env.config.show_banner = false' -c 'exit'"]
        ["minimal", "nu --no-config-file -e '$env.config.show_banner = false' -c 'exit'"]
    ]
    
    let commands = ($optimizations | get column1)
    ^hyperfine --runs $runs --warmup 3 ...$commands | str trim
}

def generate_summary_report [output_base: string, detailed: bool, compare: bool] {
    let report_file = $"($output_base).md"
    
    let header = $"# Shell Startup Performance Report
Generated: (date now | format date '%Y-%m-%d %H:%M:%S')

## Summary
This report contains the performance analysis of your Nushell startup time.

"
    
    # Read basic results if they exist
    let basic_results = if ($"($output_base)_basic.md" | path exists) {
        $"## Basic Startup Comparison\n\n(open $"($output_base)_basic.md")\n\n"
    } else { "" }
    
    let recommendations = "## Optimization Recommendations

### Based on Analysis:
1. **Monitor Starship Config**: Review `~/.config/starship/starship.toml` for expensive modules
2. **Cache Strategy**: Your config already uses good caching - monitor cache freshness
3. **Lazy Loading**: Consider lazy loading for rarely-used tools
4. **Profile Regularly**: Run this tool after config changes

### Quick Commands:
```bash
# Quick profile
nu scripts/profile-shell-startup.nu

# Detailed analysis  
nu scripts/profile-shell-startup.nu --detailed

# Compare optimizations
nu scripts/profile-shell-startup.nu --compare
```

### Performance Targets:
- **Excellent**: < 50ms
- **Good**: < 100ms  
- **Needs Work**: > 200ms

"
    
    let content = $header + $basic_results + $recommendations
    $content | save $report_file
}

# Helper function to check tool dependencies
def check_dependencies [] {
    let tools = ["hyperfine", "nu"]
    let missing = ($tools | where { |tool| (which $tool | is-empty) })
    
    if ($missing | is-not-empty) {
        print $"❌ Missing tools: ($missing | str join ', ')"
        print "Install with: mise install hyperfine"
        exit 1
    }
    true
}

# Quick profile function for convenience
def "main quick" [] {
    if not (check_dependencies) { exit 1 }
    
    print "⚡ Quick shell startup profile...\n"
    ^hyperfine --runs 5 --warmup 2 "nu -c 'exit'" | str trim
}

# Continuous monitoring function
def "main monitor" [
    --interval (-i): duration = 1hr  # How often to profile
    --threshold (-t): int = 100      # Alert if startup time > threshold (ms)
] {
    print $"🔄 Starting continuous monitoring (every ($interval))..."
    print $"⚠️  Will alert if startup time exceeds ($threshold)ms\n"
    
    loop {
        let result = (^hyperfine --runs 3 --warmup 1 --export-json /tmp/shell_monitor.json "nu -c 'exit'" | complete)
        
        if $result.exit_code == 0 {
            let data = (open /tmp/shell_monitor.json | from json)
            let mean_ms = ($data.results.0.mean * 1000 | math round)
            
            let status = if $mean_ms > $threshold { "🔴 SLOW" } else { "🟢 OK" }
            print $"(date now | format date '%H:%M:%S') - Startup: ($mean_ms)ms ($status)"
            
            if $mean_ms > $threshold {
                # Could add notification here
                print $"⚠️  Startup time exceeded threshold! Consider running detailed analysis."
            }
        }
        
        sleep $interval
    }
}