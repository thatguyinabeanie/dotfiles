#!/bin/bash
# Find packages in chezmoi homebrew config that are dependencies and don't need explicit tracking
#
# This script identifies packages listed in brews.yaml that are actually dependencies
# of other packages and would be auto-installed, so they don't need explicit tracking.
#
# Usage:
#   ./scripts/find-redundant-homebrew-packages.sh
#   ./scripts/find-redundant-homebrew-packages.sh --verbose

set -euo pipefail

VERBOSE=false
if [[ "${1:-}" == "--verbose" ]]; then
    VERBOSE=true
fi

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

log() {
    echo -e "${BLUE}🔍${NC} $1"
}

success() {
    echo -e "${GREEN}✅${NC} $1"
}

warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

info() {
    echo -e "${CYAN}💡${NC} $1"
}

main() {
    log "Finding redundant packages in homebrew config..."
    echo

    # Verify we're in a chezmoi repository
    if [[ ! -d "MISSION_CONTROL/.chezmoidata" ]]; then
        echo "❌ Error: Not in chezmoi repository root. Run from your chezmoi directory."
        exit 1
    fi

    # Verify brew is installed
    if ! command -v brew >/dev/null 2>&1; then
        echo "❌ Error: Homebrew not installed."
        exit 1
    fi

    # Get explicitly installed packages (leaves)
    log "Getting explicitly installed packages..."
    mapfile -t explicitly_installed < <(brew leaves)
    
    # Get all installed packages
    mapfile -t all_installed < <(brew list --formula)
    
    if [[ $VERBOSE == true ]]; then
        echo "Explicitly installed (leaves): ${#explicitly_installed[@]} packages"
        echo "Total installed: ${#all_installed[@]} packages"
    fi

    # Get tracked packages from homebrew config
    log "Reading homebrew configuration..."
    cd "MISSION_CONTROL/.chezmoidata/homebrew"

    # Extract all tracked brews from config (handle nested YAML structure)
    tracked_brews=()
    if [[ -f "brews.yaml" ]]; then
        # Extract packages from all sections (personal, work, shared)
        while IFS= read -r line; do
            # Look for lines with package entries (starts with spaces and dash)
            if [[ "$line" =~ ^[[:space:]]+- ]]; then
                pkg=$(echo "$line" | sed 's/^[[:space:]]*-[[:space:]]*//')
                tracked_brews+=("$pkg")
            fi
        done < brews.yaml
    fi

    if [[ $VERBOSE == true ]]; then
        echo "Tracked in config: ${#tracked_brews[@]} packages"
    fi

    # Build dependency map
    log "Building dependency map..."
    temp_deps_file=$(mktemp)
    brew deps --installed | while read -r line; do
        if [[ "$line" == *":"* ]]; then
            package=$(echo "$line" | cut -d: -f1)
            deps=$(echo "$line" | cut -d: -f2-)
            for dep in $deps; do
                [[ -n "$dep" ]] && echo "$dep:$package" >> "$temp_deps_file"
            done
        fi
    done

    get_dependents() {
        local pkg="$1"
        local deps
        if [[ -f "$temp_deps_file" ]]; then
            deps=$(grep "^$pkg:" "$temp_deps_file" 2>/dev/null | cut -d: -f2-)
            if [[ -n "$deps" ]]; then
                echo "$deps" | tr '\n' ',' | sed 's/,$//'
            fi
        fi
    }

    # Find redundant packages
    log "Analyzing tracked packages..."
    redundant_packages=()
    needed_packages=()
    
    if [[ ${#tracked_brews[@]} -eq 0 ]]; then
        echo "No packages found in brews.yaml"
        return
    fi
    
    for tracked_pkg in "${tracked_brews[@]}"; do
        # Skip tap packages (they need explicit tracking)
        if [[ "$tracked_pkg" == *"/"* ]]; then
            needed_packages+=("$tracked_pkg")
            continue
        fi
        
        # Check if this package is explicitly installed
        explicitly_installed_match=false
        for explicit_pkg in "${explicitly_installed[@]}"; do
            if [[ "$explicit_pkg" == "$tracked_pkg" ]]; then
                explicitly_installed_match=true
                break
            fi
        done
        
        if [[ "$explicitly_installed_match" == false ]]; then
            # Package is tracked but not explicitly installed
            # Check if it's actually installed at all
            installed_match=false
            for installed_pkg in "${all_installed[@]}"; do
                if [[ "$installed_pkg" == "$tracked_pkg" ]]; then
                    installed_match=true
                    break
                fi
            done
            
            if [[ "$installed_match" == true ]]; then
                # Package is installed but not explicitly - it's a dependency
                dependents=$(get_dependents "$tracked_pkg")
                if [[ -n "$dependents" ]]; then
                    redundant_packages+=("$tracked_pkg:$dependents")
                else
                    redundant_packages+=("$tracked_pkg:")
                fi
            else
                # Package is tracked but not installed at all
                if [[ $VERBOSE == true ]]; then
                    echo "  📝 $tracked_pkg is tracked but not installed"
                fi
            fi
        else
            needed_packages+=("$tracked_pkg")
        fi
    done

    echo
    if [[ ${#redundant_packages[@]} -gt 0 ]]; then
        warning "REDUNDANT PACKAGES IN CONFIG:"
        echo "============================="
        echo "These packages are dependencies and don't need explicit tracking:"
        echo
        
        for entry in "${redundant_packages[@]}"; do
            pkg=$(echo "$entry" | cut -d: -f1)
            dependents=$(echo "$entry" | cut -d: -f2-)
            if [[ -n "$dependents" ]]; then
                echo -e "  - $pkg  ${CYAN}# auto-installed by: $dependents${NC}"
            else
                echo -e "  - $pkg  ${YELLOW}# dependency (parent unknown)${NC}"
            fi
        done
        
        echo
        info "RECOMMENDATION:"
        echo "==============="
        echo "Consider removing these from your brews.yaml - they'll be auto-installed"
        echo "when needed by their parent packages."
    else
        success "No redundant packages found!"
        echo "All tracked packages are explicitly installed or taps."
    fi

    if [[ $VERBOSE == true ]] && [[ ${#needed_packages[@]} -gt 0 ]]; then
        echo
        success "CORRECTLY TRACKED PACKAGES:"
        echo "==========================="
        echo "These packages are properly tracked (explicitly installed or taps):"
        echo
        for pkg in "${needed_packages[@]}"; do
            if [[ "$pkg" == *"/"* ]]; then
                echo -e "  ✓ $pkg  ${CYAN}# tap package${NC}"
            else
                echo -e "  ✓ $pkg  ${GREEN}# explicitly installed${NC}"
            fi
        done
    fi

    echo
    echo "📊 SUMMARY:"
    echo "==========="
    echo "  Tracked packages: ${#tracked_brews[@]}"
    echo "  Explicitly installed: ${#explicitly_installed[@]}"
    echo "  Redundant in config: ${#redundant_packages[@]}"
    echo "  Properly tracked: ${#needed_packages[@]}"

    echo
    success "Analysis complete!"
    if [[ $VERBOSE == false ]]; then
        info "Run with --verbose flag to see correctly tracked packages"
    fi
    
    # Clean up temp file
    [[ -f "$temp_deps_file" ]] && rm -f "$temp_deps_file"
}

# Run main function
main "$@"