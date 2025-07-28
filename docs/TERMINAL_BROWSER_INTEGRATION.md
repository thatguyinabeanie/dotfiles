# Terminal Browser Integration Plan

## Overview

This document outlines the plan for configuring existing tmux URL handling plugins to open URLs in terminal browsers instead of system default browsers, enhancing development workflow efficiency while maintaining the current URL detection and selection functionality.

## Current Setup

The current tmux configuration already includes:
- URL detection and highlighting in terminal output
- Fuzzy finder overlay for URL selection (`tmux-fzf-url` plugin)
- Working URL extraction from git push output and other terminal content

**Goal**: Redirect selected URLs to open in terminal browsers instead of system default browser.

## Terminal Browser Options

### Lightweight Options
- **lynx**: Most mature, excellent for accessibility, basic HTML support
- **w3m**: Good table rendering, inline image support in some terminals
- **links/elinks**: Better CSS support, tabbed browsing (elinks)

### Modern Options
- **browsh**: Firefox-backed, full JavaScript/CSS support, Unicode rendering
- **carbonyl**: Chromium-based, 60 FPS rendering, full modern web standards

## Configuration Approaches

### 1. Direct Plugin Configuration (Recommended)

Configure `tmux-fzf-url` to use terminal browser:

```bash
# Add to tmux.conf
set -g @fzf-url-open "lynx -accept_all_cookies"

# Alternative options:
# set -g @fzf-url-open "w3m -M -T text/html"
# set -g @fzf-url-open "links"
# set -g @fzf-url-open "browsh --startup-url"
# set -g @fzf-url-open "carbonyl"
```

### 2. Environment Variable Approach

Set system-wide terminal browser preference:

```bash
# Add to shell configuration (.zshrc, .bashrc, etc.)
export BROWSER="lynx"
```

### 3. Smart URL Handler (Advanced)

Create conditional handling for different URL types:

```bash
#!/bin/bash
# ~/.local/bin/terminal-url-handler
url="$1"

case "$url" in
    *github.com*|*gitlab.com*)
        # GitHub/GitLab: use w3m for better formatting
        w3m -M -T text/html "$url"
        ;;
    *localhost*|*127.0.0.1*)
        # Local development: use browsh for full JS support
        browsh --startup-url "$url"
        ;;
    *)
        # Default: lightweight lynx
        lynx -accept_all_cookies "$url"
        ;;
esac
```

Then configure tmux:
```bash
set -g @fzf-url-open "terminal-url-handler"
```

## Implementation Steps

### Phase 1: Basic Terminal Browser Integration
1. **Install terminal browser**: Choose primary terminal browser (recommend starting with `lynx`)
2. **Configure tmux-fzf-url**: Add `@fzf-url-open` setting to tmux configuration
3. **Test workflow**: Verify URLs open in terminal browser instead of system browser
4. **Optimize browser settings**: Configure terminal browser options for best experience

### Phase 2: Enhanced Configuration
1. **Install additional browsers**: Add `w3m`, `browsh`, or `carbonyl` for different use cases
2. **Create smart handler**: Implement conditional URL routing based on URL patterns
3. **Optimize tmux appearance**: Configure fzf popup options for better UX
4. **Add keybinding customization**: Adjust tmux keybindings if needed

### Phase 3: Workflow Integration
1. **Performance testing**: Evaluate different browsers for common development URLs
2. **Custom configurations**: Create browser-specific configuration files
3. **Documentation**: Document preferred settings and usage patterns
4. **Backup integration**: Ensure fallback to system browser when needed

## Terminal Browser Command Options

### Lynx Configuration
```bash
# Basic usage
lynx -accept_all_cookies "$url"

# Advanced options
lynx -accept_all_cookies -dump -nolist "$url"  # For text extraction
lynx -cfg ~/.lynxrc "$url"  # Custom config file
```

### w3m Configuration
```bash
# Basic usage
w3m -M -T text/html "$url"

# With options
w3m -M -cookie -T text/html -o auto_image=TRUE "$url"
```

### Browsh Configuration
```bash
# Basic usage
browsh --startup-url "$url"

# With options
browsh --startup-url "$url" --debug --time-limit=0
```

## tmux-fzf-url Additional Settings

```bash
# Complete configuration block for tmux.conf
set -g @plugin 'wfxr/tmux-fzf-url'
set -g @fzf-url-open "lynx -accept_all_cookies"
set -g @fzf-url-bind 'u'  # Keybinding (default)
set -g @fzf-url-fzf-options '--tmux center,80%,60% --multi --exit-0 --no-preview'
set -g @fzf-url-history-limit '3000'
```

## Expected Benefits

### Development Workflow Improvements
- **Faster URL access**: No context switching to external browser
- **Keyboard-centric workflow**: Maintain terminal-focused development environment
- **Reduced resource usage**: Lightweight browsers consume less memory/CPU
- **SSH compatibility**: Works seamlessly over SSH connections
- **Consistent interface**: Unified terminal experience

### Use Case Scenarios
- **GitHub PR URLs**: Quick review of PR descriptions and changes
- **Documentation links**: Fast access to API docs and README files
- **Local development servers**: View localhost applications without browser switching
- **CI/CD links**: Check build status and deployment information
- **Issue tracking**: Quick access to bug reports and feature requests

## Fallback Strategies

### Browser Availability Checking
```bash
# Check if terminal browser is available
if command -v lynx >/dev/null 2>&1; then
    lynx "$url"
else
    # Fallback to system default
    open "$url"  # macOS
    # xdg-open "$url"  # Linux
fi
```

### Hybrid Approach
- Keep original browser opening as secondary option
- Add tmux keybinding for system browser when needed
- Configure different keybindings for different browser types

## Installation Requirements

### Terminal Browsers
```bash
# macOS with Homebrew
brew install lynx w3m links

# For modern browsers (optional)
brew install browsh  # If available
# carbonyl requires manual installation

# Linux (Ubuntu/Debian)
sudo apt install lynx w3m links elinks

# Linux (RHEL/CentOS)
sudo yum install lynx w3m links elinks
```

### Configuration Files
- Terminal browser config files (`.lynxrc`, `.w3m/config`, etc.)
- Smart URL handler script
- Updated tmux configuration

## Testing Plan

### Validation Steps
1. **URL detection**: Verify existing URL detection still works
2. **Selection interface**: Confirm fzf overlay functions correctly
3. **Browser opening**: Test URLs open in configured terminal browser
4. **Performance**: Evaluate loading times and responsiveness
5. **Compatibility**: Test with various URL types (GitHub, docs, localhost)

### Test Cases
- GitHub PR URLs from git push output
- Documentation links from terminal output
- Local development server URLs
- Various domain types and URL structures
- Long URLs and URLs with parameters

## Maintenance Considerations

### Regular Tasks
- Update terminal browser configurations for optimal performance
- Review and update smart URL handler patterns
- Monitor tmux plugin updates for new features
- Backup configuration files with chezmoi

### Troubleshooting
- Browser compatibility issues with specific websites
- Terminal rendering problems
- Performance optimization needs
- Plugin conflicts or updates

## Success Metrics

- Reduced time to access URLs from terminal
- Decreased context switching between terminal and browser
- Improved development workflow efficiency
- Maintained or improved URL accessibility
- Successful integration with existing tmux setup

## Future Enhancements

### Potential Improvements
- Custom terminal browser themes matching system theme
- Integration with terminal multiplexer sessions
- Bookmarking system for frequently accessed URLs
- History and caching optimizations
- Advanced URL pattern matching and routing

### Integration Opportunities
- Combine with existing development tools and scripts
- Enhance with shell aliases and functions
- Integrate with git workflow automation
- Connect with documentation and note-taking systems