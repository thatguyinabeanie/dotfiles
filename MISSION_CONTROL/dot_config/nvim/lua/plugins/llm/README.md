# LLM (Large Language Model) Plugins

This directory contains Neovim plugins for integrating AI-powered coding assistants and Large Language Models.

## Active Plugins (Always Loaded)

### avante.nvim

- **File**: `avante.lua`
- **Purpose**: Cursor-like AI IDE experience in Neovim
- **Features**:
  - Side-by-side code suggestions
  - One-click code application
  - Multiple AI provider support (Copilot, OpenAI, Claude)
- **Key Mappings**:
  - `<leader>aa` - Ask AI
  - `<leader>ae` - Edit with AI
  - `<leader>ar` - Refresh suggestions

### claude-code.nvim

- **File**: `claude-code.lua`
- **Purpose**: Claude AI integration via MCP (Model Context Protocol)
- **Features**:
  - Direct Claude API access
  - Context-aware code suggestions
  - Multiple conversation management
- **Key Mappings**:
  - `<C-a>` - Accept Claude suggestion

## Lazy-Loaded Plugins

### codecompanion.nvim

- **File**: `codecompanion.lua`
- **Purpose**: Universal AI companion supporting multiple providers
- **Loading**: On command/keymap
- **Key Mappings**:
  - `<leader>cc` - Toggle CodeCompanion chat
  - `<leader>ca` - CodeCompanion actions

### copilot.lua

- **File**: `copilot.lua`
- **Purpose**: GitHub Copilot autocomplete suggestions
- **Loading**: On InsertEnter event
- **Features**:
  - Inline code suggestions
  - Multi-line completions
  - Context-aware suggestions

### CopilotChat.nvim

- **File**: `copilot-chat.lua`
- **Purpose**: Interactive chat interface for GitHub Copilot
- **Loading**: Lazy loaded with keymaps
- **Key Mappings**:
  - `<leader>pc` - Toggle Copilot chat
  - `<leader>pe` - Explain code
  - `<leader>pv` - Review code
  - `<leader>pf` - Fix code
  - `<leader>po` - Optimize code
  - `<leader>pd` - Generate docs
  - `<leader>pt` - Generate tests

### mcp-hub.nvim

- **File**: `mcp-hub.lua`
- **Purpose**: Model Context Protocol hub for managing AI models
- **Features**:
  - Centralized AI model management
  - Provider switching
  - Context management

## Configuration Notes

- Primary AI providers are Avante and Claude Code (always loaded for immediate access)
- Other AI tools are lazy-loaded to optimize startup time
- All plugins support multiple AI providers (OpenAI, Claude, Copilot, etc.)
- Provider configurations are centralized in the `providers` section of each plugin
