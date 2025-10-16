# Error handling and logging utilities for shell scripts
# Provides consistent logging, error handling, and utility functions

set -euo pipefail

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly GRAY='\033[0;90m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_debug() {
  if [[ "${DEBUG:-false}" == "true" ]]; then
    echo -e "${GRAY}[DEBUG]${NC} $1" >&2
  fi
}

log_header() {
  echo -e "\n${WHITE}=== $1 ===${NC}"
}

log_substep() {
  echo -e "${CYAN}  → $1${NC}"
}

log_step() {
  echo -e "${PURPLE}▶ $1${NC}"
}

# Utility functions
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

is_macos() {
  [[ "$(uname -s)" == "Darwin" ]]
}

is_linux() {
  [[ "$(uname -s)" == "Linux" ]]
}

is_arm64() {
  [[ "$(uname -m)" == "arm64" ]]
}

is_x86_64() {
  [[ "$(uname -m)" == "x86_64" ]]
}

# Error handling functions
handle_error() {
  local exit_code=$?
  local line_number=$1
  log_error "Script failed at line $line_number with exit code $exit_code"
  exit $exit_code
}

# Set up error trap
trap 'handle_error $LINENO' ERR

# Cleanup function
cleanup() {
  local exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    log_error "Script exited with error code $exit_code"
  fi
}

# Set up exit trap
trap cleanup EXIT

# Progress tracking
show_progress() {
  local current=$1
  local total=$2
  local item=$3
  local percent=$((current * 100 / total))
  echo -e "${BLUE}[$current/$total - ${percent}%]${NC} $item"
}

# File operations with error checking
safe_mkdir() {
  local dir="$1"
  if [[ ! -d "$dir" ]]; then
    mkdir -p "$dir" || {
      log_error "Failed to create directory: $dir"
      return 1
    }
    log_debug "Created directory: $dir"
  fi
}

safe_copy() {
  local src="$1"
  local dest="$2"
  if [[ ! -f "$src" ]]; then
    log_error "Source file does not exist: $src"
    return 1
  fi
  cp "$src" "$dest" || {
    log_error "Failed to copy $src to $dest"
    return 1
  }
  log_debug "Copied $src to $dest"
}

safe_move() {
  local src="$1"
  local dest="$2"
  if [[ ! -f "$src" ]]; then
    log_error "Source file does not exist: $src"
    return 1
  fi
  mv "$src" "$dest" || {
    log_error "Failed to move $src to $dest"
    return 1
  }
  log_debug "Moved $src to $dest"
}

# Network operations
download_file() {
  local url="$1"
  local output="$2"
  local temp_file="${output}.tmp"

  if command_exists curl; then
    curl -fsSL "$url" -o "$temp_file" || {
      log_error "Failed to download $url"
      rm -f "$temp_file"
      return 1
    }
  elif command_exists wget; then
    wget -q "$url" -O "$temp_file" || {
      log_error "Failed to download $url"
      rm -f "$temp_file"
      return 1
    }
  else
    log_error "Neither curl nor wget is available"
    return 1
  fi

  mv "$temp_file" "$output"
  log_debug "Downloaded $url to $output"
}

# Process management
wait_for_process() {
  local process_name="$1"
  local timeout="${2:-30}"
  local count=0

  while ! pgrep -f "$process_name" >/dev/null 2>&1; do
    if [[ $count -ge $timeout ]]; then
      log_error "Timeout waiting for process: $process_name"
      return 1
    fi
    sleep 1
    ((count++))
  done
  log_debug "Process $process_name is running"
}

# Validation functions
validate_not_empty() {
  local var_name="$1"
  local var_value="$2"
  if [[ -z "$var_value" ]]; then
    log_error "$var_name cannot be empty"
    return 1
  fi
}

validate_file_exists() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    log_error "File does not exist: $file"
    return 1
  fi
}

validate_dir_exists() {
  local dir="$1"
  if [[ ! -d "$dir" ]]; then
    log_error "Directory does not exist: $dir"
    return 1
  fi
}

# Retry mechanism
retry() {
  local max_attempts="$1"
  local delay="$2"
  shift 2
  local command=("$@")
  local attempt=1

  while [[ $attempt -le $max_attempts ]]; do
    if "${command[@]}"; then
      return 0
    fi

    if [[ $attempt -lt $max_attempts ]]; then
      log_warning "Command failed (attempt $attempt/$max_attempts), retrying in ${delay}s..."
      sleep "$delay"
    fi
    ((attempt++))
  done

  log_error "Command failed after $max_attempts attempts: ${command[*]}"
  return 1
}

# Confirmation prompts
confirm() {
  local message="$1"
  local default="${2:-n}"
  local prompt

  if [[ "$default" == "y" ]]; then
    prompt="[Y/n]"
  else
    prompt="[y/N]"
  fi

  echo -n -e "${YELLOW}$message $prompt${NC} "
  read -r response

  if [[ -z "$response" ]]; then
    response="$default"
  fi

  case "$response" in
  [yY] | [yY][eE][sS])
    return 0
    ;;
  *)
    return 1
    ;;
  esac
}

# Performance timing
start_timer() {
  TIMER_START=$(date +%s)
}

end_timer() {
  local timer_end=$(date +%s)
  local duration=$((timer_end - TIMER_START))
  local minutes=$((duration / 60))
  local seconds=$((duration % 60))

  if [[ $minutes -gt 0 ]]; then
    echo "${minutes}m ${seconds}s"
  else
    echo "${seconds}s"
  fi
}

# Initialize timer
TIMER_START=$(date +%s)
