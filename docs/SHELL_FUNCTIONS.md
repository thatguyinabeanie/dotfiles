# Shell Functions Reference

Comprehensive guide to the advanced shell functions available in both Zsh and Nushell configurations.

## 🐚 Git & GitHub Functions

### `git_emoji_commit`
**Purpose**: Create commits with emoji prefixes for better visual categorization
**Usage**: `git_emoji_commit "your commit message"`

```bash
# Interactive emoji selection with fzf
git_emoji_commit "fix user authentication bug"
# Shows: 🐛 fix user authentication bug
```

**Available Emojis**:
- 🚀 `:rocket:` - New features
- 🐛 `:bug:` - Bug fixes  
- 📚 `:books:` - Documentation
- 🎨 `:art:` - Code style/formatting
- ⚡ `:zap:` - Performance improvements
- 🔧 `:wrench:` - Configuration changes

### GitHub Repository Management

#### `gh-create-repo`
**Purpose**: Create GitHub repositories with optional privacy and description
**Usage**: `gh-create-repo <name> [--private] [--description "desc"]`

```bash
# Public repository
gh-create-repo my-project --description "My awesome project"

# Private repository
gh-create-repo secret-project --private --description "Internal tool"
```

#### `gh-clone-repo`
**Purpose**: Clone repositories with optional destination directory
**Usage**: `gh-clone-repo <repo> [--destination dir]`

```bash
# Clone to current directory
gh-clone-repo username/repo-name

# Clone to specific directory
gh-clone-repo username/repo-name --destination ~/projects/
```

#### `gh-list-repos`
**Purpose**: List repositories with pagination support
**Usage**: `gh-list-repos [--limit 30]`

```bash
# List default number of repos
gh-list-repos

# List specific number
gh-list-repos --limit 50
```

## 🐳 Docker Management

### `docker_purge` / `docker_nuke`
**Purpose**: Complete Docker system cleanup
**Usage**: `docker_purge [--force]`

⚠️ **WARNING**: These commands remove ALL Docker containers, volumes, images, networks, and build cache.

```bash
# Interactive cleanup with confirmation prompts
docker_purge

# Force cleanup without prompts (dangerous!)
docker_purge --force
# or
docker_nuke
```

**What gets removed**:
- All stopped containers
- All unused networks
- All volumes not used by containers
- All images without containers
- All build cache

**Safety Features**:
- Interactive confirmation prompts
- Clear warnings about data loss
- Option to abort at any stage

## 🎵 macOS Spotify Integration

### Spotify Controls
**Purpose**: Control Spotify playback from terminal (macOS only)

```bash
spotify_play     # Resume/start playback
spotify_pause    # Pause playback
spotify_next     # Skip to next track
spotify_prev     # Go to previous track
```

**Requirements**: Spotify app installed and running on macOS

## 📝 Obsidian Vault Management

### `obsidian_nvim`
**Purpose**: Quick switching between Obsidian vaults in Neovim
**Usage**: `obsidian_nvim [vault_name]`

```bash
# Available vaults
obsidian_nvim personal      # Personal knowledge base
obsidian_nvim work          # Work notes
obsidian_nvim smart-notes   # Smart notes vault
obsidian_nvim bramses       # Bramses vault
```

**Integration Features**:
- Automatic vault detection
- Neovim-Obsidian plugin integration
- Template and configuration sync

## 🖥️ System Information

### `poke_system_info`
**Purpose**: Display system information with Pokemon-themed styling
**Usage**: `poke_system_info`

```bash
# Shows animated system info with Pokemon ASCII art
poke_system_info
```

**Information displayed**:
- OS version and kernel
- Hardware specifications
- Memory and disk usage
- Network configuration
- Installed packages count

## 📁 File Management

### Enhanced File Operations
These functions override standard commands with improved versions:

```bash
y           # Launch Yazi file manager
cat         # Enhanced with bat (syntax highlighting)
ls/l/la     # Enhanced with eza (better formatting)
```

## 🛠️ Advanced Functions (Nushell-specific)

These examples show the Nushell implementations of functions that are also available in Bash/Zsh with equivalent functionality.

### Repository Cloning with Error Handling
```nushell
# Nushell implementation with enhanced error handling
def gh-clone-repo [repo: string, --destination (-d): string] {
    let dest = if ($destination | is-empty) { "." } else { $destination }
    try {
        gh repo clone $repo $dest
        print $"✅ Successfully cloned ($repo)"
    } catch {
        print $"❌ Failed to clone ($repo)"
    }
}
```

### Safe Docker Operations
```nushell
# Nushell implementation with interactive confirmation
def docker_purge [--force (-f)] {
    if not $force {
        print "⚠️  WARNING: This will remove ALL Docker data!"
        let confirm = (input "Continue? (y/N): ")
        if $confirm != "y" { return }
    }
    
    print "🧹 Cleaning Docker system..."
    docker system prune --all --volumes --force
    print "✅ Docker cleanup complete"
}
```

## 🔧 Configuration & Setup

### Function Discovery
Functions are automatically loaded from:
- **Zsh**: `MISSION_CONTROL/dot_config/zsh/aliases.zsh`
- **Nushell**: `MISSION_CONTROL/dot_config/nushell/aliases.nu.tmpl`

### Customization
Add your own functions by editing the respective alias files. Functions support:
- Parameter validation
- Error handling
- Interactive prompts
- Cross-platform compatibility checks

### Dependencies
Some functions require external tools:
- **fzf**: For interactive selections
- **gh**: GitHub CLI for repository operations
- **bat**: Enhanced file viewing
- **eza**: Modern ls replacement
- **yazi**: Terminal file manager

## 🚨 Safety Guidelines

### Destructive Operations
Functions that modify or delete data include safety measures:

1. **Confirmation prompts** for dangerous operations
2. **`--force` flags** to bypass prompts in scripts
3. **Clear warnings** about data loss
4. **Graceful error handling** with helpful messages

### Best Practices
- Always read function documentation before use
- Test destructive functions in safe environments first
- Use `--force` flags only in automated scripts
- Keep backups of important data before cleanup operations

## 📋 Quick Reference

| Category | Function | Purpose |
|----------|----------|---------|
| **Git** | `git_emoji_commit` | Emoji-prefixed commits |
| **GitHub** | `gh-create-repo` | Create repositories |
| **GitHub** | `gh-clone-repo` | Clone repositories |
| **GitHub** | `gh-list-repos` | List repositories |
| **Docker** | `docker_purge` | Complete cleanup |
| **Media** | `spotify_*` | Spotify controls |
| **Notes** | `obsidian_nvim` | Vault switching |
| **System** | `poke_system_info` | System information |
| **Files** | `y` | File manager |

These functions provide a powerful toolkit for development workflows, system management, and productivity enhancement across both Zsh and Nushell environments.