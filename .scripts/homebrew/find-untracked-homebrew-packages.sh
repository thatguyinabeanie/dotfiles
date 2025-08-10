#!/bin/bash
# Find Homebrew packages that are installed but not tracked in chezmoi configuration
# 
# This script analyzes your installed Homebrew packages and compares them against:
# - Homebrew packages tracked in .chezmoidata/packages/macos/*.yaml
# - Packages managed by mise in .chezmoidata/packages/mise/*.yaml
# 
# Usage:
#   ./scripts/find-untracked-homebrew-packages.sh
#   ./scripts/find-untracked-homebrew-packages.sh --verbose

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
    log "Finding TRULY untracked Homebrew packages (excluding mise-managed)..."
    echo

    # Verify we're in a chezmoi repository
    CHEZMOI_ROOT=$(chezmoi source-path 2>/dev/null || echo "")
    if [[ -z "$CHEZMOI_ROOT" || ! -d "$CHEZMOI_ROOT/.chezmoidata" ]]; then
        echo "❌ Error: Not in chezmoi repository root. Ensure chezmoi is installed and run this script from your chezmoi directory."
        exit 1
    fi

    # Verify brew is installed
    if ! command -v brew >/dev/null 2>&1; then
        echo "❌ Error: Homebrew not installed."
        exit 1
    fi

    # Get installed packages
    log "Getting installed Homebrew packages..."
    installed_formulae=()
    while IFS= read -r line; do
        installed_formulae+=("$line")
    done < <(brew leaves)
    
    installed_casks=()
    while IFS= read -r line; do
        installed_casks+=("$line")
    done < <(brew list --cask)
    
    # Build dependency map (much faster bulk approach)
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
                echo "$deps" | tr '\n' ',' | head -c -1
            fi
        fi
    }
    
    if [[ $VERBOSE == true ]]; then
        echo "Found ${#installed_formulae[@]} formulae and ${#installed_casks[@]} casks"
    fi

    # Get tracked packages from homebrew config files
    log "Reading chezmoi homebrew configuration..."
    cd "$CHEZMOI_ROOT/.chezmoidata/packages/macos"

    # Extract tracked brews (keep full tap names for proper comparison)
    tracked_brews=$(grep -E '^\s*-\s+' brews.yaml | sed 's/^\s*-\s*//' | sort -u)

    # Extract tracked casks
    tracked_casks=$(grep -E '^\s*-\s+' casks.yaml | sed 's/^\s*-\s*//' | sort -u)

    # Extract tracked fonts  
    tracked_fonts=$(grep -E '^\s*-\s+' fonts.yaml | sed 's/^\s*-\s*//' | sort -u)

    # Extract tracked taps
    tracked_taps=""
    if [[ -f "taps.yaml" ]]; then
        tracked_taps=$(grep -E '^\s*-\s+' taps.yaml | sed 's/^\s*-\s*//' | sort -u)
    fi

    # Get mise-managed packages
    log "Reading mise configuration..."
    cd "$CHEZMOI_ROOT/.chezmoidata/packages/mise"
    mise_tools=""
    if [[ -f "packages/tools.yaml" ]]; then
        mise_tools_temp=$(grep -E '^\s*-\s+name:\s+' packages/tools.yaml | sed 's/.*name:\s*//' | tr -d '"' || true)
        mise_tools="$mise_tools_temp"
    fi
    if [[ -f "packages/languages.yaml" ]]; then
        mise_lang_temp=$(grep -E '^\s*-\s+name:\s+' packages/languages.yaml | sed 's/.*name:\s*//' | tr -d '"' || true)
        mise_tools="$mise_tools"$'\n'"$mise_lang_temp"
    fi
    if [[ -f "packages/node.yaml" ]]; then
        mise_node_temp=$(grep -E '^\s*-\s+name:\s+' packages/node.yaml | sed 's/.*name:\s*//' | tr -d '"' || true)
        mise_tools="$mise_tools"$'\n'"$mise_node_temp"
    fi
    mise_tools=$(echo "$mise_tools" | grep -v '^$' | sort -u)

    # Combine all tracked packages (if needed in the future)

    # Function to check if a tap package should be considered tracked
    is_tap_package_tracked() {
        local package="$1"
        # First check if the specific package is tracked in brews.yaml
        if echo "$tracked_brews" | grep -q "^$package$"; then
            return 0  # Explicitly tracked
        fi
        # If it's a tap package, check if the tap itself is tracked
        if [[ "$package" == *"/"* ]]; then
            local tap
            tap=$(echo "$package" | cut -d/ -f1-2)
            if echo "$tracked_taps" | grep -q "^$tap$"; then
                return 0  # Tap is tracked
            fi
        fi
        return 1  # Not tracked
    }

    if [[ $VERBOSE == true ]]; then
        echo "Tracked via homebrew config: $(echo "$tracked_brews $tracked_casks $tracked_fonts" | wc -w | tr -d ' ') packages"
        echo "Tracked via mise: $(echo "$mise_tools" | wc -w | tr -d ' ') packages"
    fi

    # Define dependency patterns to filter out (these are typically auto-installed)
    dependency_patterns="^(lib|aws-c-|aws-sdk|protobuf|python@|gcc@|llvm@|icu4c|openssl|ca-certificates|certifi|cffi|cryptography|brotli|c-ares|cairo|cjson|freetype|fribidi|gettext|gdbm|giflib|graphite2|highway|hwloc|imath|isl|jasper|jpeg-|krb5|lame|leptonica|little-cms2|lz4|lzo|m4|mbedtls|mpdecimal|mpfr|mpg123|netpbm|nettle|npth|nspr|nss|oniguruma|open-mpi|opencore-amr|openexr|openjpeg|opus|p11-kit|pango|pcre|pinentry|pixman|pmix|pycatcher|rav1e|re2|rtmpdump|rubberband|shared-mime-info|simdjson|snappy|speex|sqlite|srt|svt-av1|tesseract|theora|thrift|unbound|unibilium|utf8proc|webp|x264|x265|xorgproto|xvid|zimg|zlib|z3|zeromq|aribb24|aom|apache-arrow|dav1d|fftw|flac|frei0r|gd|gdk-pixbuf|gnupg|gnutls|gpgme|gts|liquid-dsp|lpeg|luv|abseil)"

    # Analyze formulae (brews)
    untracked_brews=()
    mise_managed_but_also_homebrew=()
    for formula in "${installed_formulae[@]}"; do
        # Check if tracked (either explicitly or via tap)
        if ! is_tap_package_tracked "$formula"; then
            # Skip obvious dependencies
            if ! echo "$formula" | grep -qE "$dependency_patterns"; then
                # Check if this is managed by mise
                if echo "$mise_tools" | grep -q "^$formula$"; then
                    mise_managed_but_also_homebrew+=("$formula")
                else
                    untracked_brews+=("$formula")
                fi
            fi
        fi
    done

    # Analyze casks
    untracked_casks=()
    all_tracked_casks=$(echo -e "$tracked_casks\n$tracked_fonts" | sort -u)
    for cask in "${installed_casks[@]}"; do
        if ! echo "$all_tracked_casks" | grep -q "^$cask$"; then
            untracked_casks+=("$cask")
        fi
    done

    total_untracked=$((${#untracked_brews[@]} + ${#untracked_casks[@]}))
    
    if [[ $total_untracked -eq 0 ]]; then
        echo
        success "No untracked packages found!"
    else
        echo
        info "CONFIG ADDITIONS NEEDED:"
        echo "========================"
        
        if [[ ${#untracked_brews[@]} -gt 0 ]]; then
            echo "Add to .chezmoidata/packages/macos/brews.yaml:"
            sorted_brews=()
            while IFS= read -r line; do
                sorted_brews+=("$line")
            done < <(printf '%s\n' "${untracked_brews[@]}" | sort)
            for pkg in "${sorted_brews[@]}"; do
                dependents_list=$(get_dependents "$pkg")
                if [[ -n "$dependents_list" ]]; then
                    echo -e "  - $pkg  ${CYAN}# used by: $dependents_list${NC}"
                else
                    echo -e "  - $pkg  ${YELLOW}# standalone${NC}"
                fi
            done
            echo
        fi
        
        if [[ ${#untracked_casks[@]} -gt 0 ]]; then
            echo "Add to .chezmoidata/packages/macos/casks.yaml:"
            sorted_casks=()
            while IFS= read -r line; do
                sorted_casks+=("$line")
            done < <(printf '%s\n' "${untracked_casks[@]}" | sort)
            for cask in "${sorted_casks[@]}"; do
                dependents_list=$(get_dependents "$cask")
                if [[ -n "$dependents_list" ]]; then
                    echo -e "  - $cask  ${CYAN}# used by: $dependents_list${NC}"
                else
                    echo -e "  - $cask  ${YELLOW}# standalone${NC}"
                fi
            done
            echo
        fi
    fi

    # Show packages managed by mise but also installed via homebrew
    if [[ ${#mise_managed_but_also_homebrew[@]} -gt 0 ]]; then
        warning "MISE CONFLICTS:"
        echo "==============="
        echo "Remove from Homebrew to avoid conflicts:"
        sorted_mise=()
        while IFS= read -r line; do
            sorted_mise+=("$line")
        done < <(printf '%s\n' "${mise_managed_but_also_homebrew[@]}" | sort)
        for pkg in "${sorted_mise[@]}"; do
            echo "    brew uninstall $pkg"
        done
        echo
    fi

    echo
    echo "📊 SUMMARY:"
    echo "==========="
    echo "  Untracked brews: ${#untracked_brews[@]}"
    echo "  Untracked casks: ${#untracked_casks[@]}"
    echo "  Mise conflicts: ${#mise_managed_but_also_homebrew[@]}"

    if [[ $VERBOSE == true ]]; then
        echo
        info "VERIFICATION - Packages managed by mise:"
        echo "========================================"
        mise_managed_found=()
        for formula in "${installed_formulae[@]}"; do
            if echo "$mise_tools" | grep -q "^$formula$"; then
                mise_managed_found+=("$formula")
            fi
        done

        if [[ ${#mise_managed_found[@]} -gt 0 ]]; then
            for pkg in "${mise_managed_found[@]}"; do
                echo "  ✓ $pkg"
            done
        else
            echo "  No packages found that are managed by mise."
        fi
    fi

    echo
    success "Analysis complete!"
    if [[ $VERBOSE == false ]]; then
        info "Run with --verbose flag to see packages managed by mise"
    fi
    
    # Clean up temp file
    [[ -f "$temp_deps_file" ]] && rm -f "$temp_deps_file"
}

# Run main function
main "$@"