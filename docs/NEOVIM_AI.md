# Neovim AI Integration

Comprehensive guide to the AI-powered development tools integrated into this Neovim configuration.

## 🤖 Available AI Tools

### 1. **Avante.nvim** - Claude Integration
Primary AI assistant for code generation, refactoring, and problem-solving.

**Keybinding**: `<leader>aa`
**Provider**: Anthropic Claude
**Features**:
- Code generation and completion
- Refactoring suggestions
- Bug fix recommendations
- Code explanation and documentation

### 2. **CodeCompanion** - Multi-Provider Chat
Flexible chat interface supporting multiple AI providers.

**Keybinding**: `<leader>cc`
**Providers**: Claude, GPT-4, Gemini (configurable)
**Features**:
- Interactive chat sessions
- Code context sharing
- Multi-turn conversations
- Provider switching

### 3. **GitHub Copilot** - Code Completion
Real-time code suggestions and autocompletion.

**Keybinding**: `<C-g>` (show suggestions)
**Provider**: GitHub/OpenAI
**Features**:
- Inline code suggestions
- Function/method completion
- Comment-to-code generation
- Multi-language support

## 🔧 Configuration Overview

### Avante.nvim Setup
```lua
-- File: lua/plugins/ai/avante.lua
{
  "yetone/avante.nvim",
  event = "VeryLazy",
  opts = {
    provider = "claude",
    auto_suggestions = false,  -- Prevent conflicts with Copilot
    mappings = {
      ask = "<leader>aa",      -- Open AI assistant
      edit = "<leader>ae",     -- Edit with AI
      refresh = "<leader>ar",  -- Refresh AI response
    },
  },
}
```

### CodeCompanion Configuration
```lua
-- File: lua/plugins/ai/codecompanion.lua
{
  "olimorris/codecompanion.nvim",
  cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionToggle" },
  opts = {
    strategies = {
      chat = {
        adapter = "anthropic",  -- Default to Claude
      },
      inline = {
        adapter = "copilot",    -- Use Copilot for inline
      },
    },
  },
}
```

### MCP Hub Integration
Model Context Protocol servers for enhanced functionality.

```lua
-- File: lua/plugins/ai/mcp-hub.lua
{
  "thatguyinabeanie/mcp-hub.nvim",
  config = function()
    require("mcp-hub").setup({
      servers = {
        filesystem = { command = "npx", args = { "-y", "@modelcontextprotocol/server-filesystem" } },
        git = { command = "mcp-server-git", args = { "--repository", vim.fn.getcwd() } },
      },
    })
  end,
}
```

## 🚀 Usage Workflows

### 1. Code Generation Workflow
```lua
-- 1. Open Avante
<leader>aa

-- 2. Describe what you want
"Create a React component for user authentication with TypeScript"

-- 3. Review generated code
-- 4. Accept or request modifications
```

### 2. Code Review & Refactoring
```lua
-- 1. Select code block (visual mode)
-- 2. Open CodeCompanion
<leader>cc

-- 3. Ask for review or refactoring
"Review this function for performance and suggest improvements"
```

### 3. Interactive Debugging
```lua
-- 1. Place cursor on error line
-- 2. Use Avante for explanation
<leader>aa
"Explain this error and suggest a fix"

-- 3. Apply suggested solution
```

### 4. Documentation Generation
```lua
-- 1. Select function/class
-- 2. Open AI assistant
<leader>aa
"Generate comprehensive documentation for this code"
```

## ⚙️ Advanced Configuration

### API Key Management
```bash
# Set up API keys (add to your shell profile)
export ANTHROPIC_API_KEY="your_claude_key"
export OPENAI_API_KEY="your_openai_key" 
export GEMINI_API_KEY="your_gemini_key"

# For Claude Sonnet 4 via GitHub Copilot (recommended)
# No additional API key needed - uses your GitHub Copilot subscription
```

### Claude Sonnet 4 Setup

All AI tools in this configuration are now set to use **Claude Sonnet 4** (`claude-sonnet-4-20250514`) via GitHub Copilot. This provides:

- **CodeCompanion**: Full chat interface with Claude Sonnet 4
- **CopilotChat**: Enhanced chat with Claude Sonnet 4 models  
- **Avante**: AI-powered editing with Claude Sonnet 4

#### Prerequisites
1. Active GitHub Copilot subscription
2. Copilot authenticated in Neovim (run `:Copilot setup` if not already done)

#### Testing Your Setup
```bash
# Check if Copilot is properly authenticated
echo $COPILOT_API_KEY  # Should show your token (if using direct API)

# Or test in Neovim
nvim -c ":Copilot setup"
```

### Custom Prompts
Create custom prompts for common tasks:

```lua
-- Add to your Neovim config
local custom_prompts = {
  code_review = "Review this code for:\n- Performance issues\n- Security vulnerabilities\n- Best practices\n- Code style",
  optimize = "Optimize this code for:\n- Performance\n- Memory usage\n- Readability", 
  test_gen = "Generate comprehensive unit tests for this function including edge cases",
}
```

### Provider Switching
Switch between AI providers based on task:

```lua
-- Quick provider switching
vim.keymap.set("n", "<leader>ac", function()
  -- Switch to Claude for complex reasoning
  require("codecompanion").setup({ adapter = "anthropic" })
end)

vim.keymap.set("n", "<leader>ag", function()
  -- Switch to GPT-4 for general tasks
  require("codecompanion").setup({ adapter = "openai" })
end)
```

## 🔐 Security & Privacy

### Data Handling
- **Code Context**: Only selected text is sent to AI providers
- **API Keys**: Stored locally in environment variables
- **Privacy**: No automatic data collection or telemetry

### Best Practices
1. **Review AI suggestions** before accepting
2. **Don't send sensitive data** (passwords, keys, personal info)
3. **Test generated code** thoroughly
4. **Keep API keys secure** and rotate regularly

### Corporate Usage
For work environments:
```lua
-- Disable AI features for sensitive projects
if vim.fn.getcwd():match("sensitive%-project") then
  vim.g.disable_ai_tools = true
end
```

## 🛠️ Troubleshooting

### Common Issues

#### API Key Not Found
```bash
# Check if environment variables are set
echo $ANTHROPIC_API_KEY
echo $OPENAI_API_KEY

# Add to shell profile if missing
export ANTHROPIC_API_KEY="your_key_here"
```

#### Rate Limiting
```lua
-- Adjust request frequency in config
opts = {
  request_timeout = 30,
  max_tokens = 4096,
  temperature = 0.1,  -- Lower for more consistent results
}
```

#### Plugin Conflicts
```lua
-- Check for conflicting keybindings
:verbose map <leader>aa
:verbose map <C-g>

-- Resolve conflicts by remapping
vim.keymap.del("n", "<leader>aa")  -- Remove conflicting mapping
```

### Performance Optimization
```lua
-- Lazy load AI plugins to improve startup time
{
  "yetone/avante.nvim",
  event = "VeryLazy",        -- Load only when needed
  cond = function()
    return vim.env.ANTHROPIC_API_KEY ~= nil  -- Only if API key present
  end,
}
```

## 📋 Keybinding Reference

| Key | Plugin | Action |
|-----|--------|--------|
| `<leader>aa` | Avante | Open AI assistant |
| `<leader>ae` | Avante | Edit with AI |
| `<leader>ar` | Avante | Refresh AI response |
| `<leader>cc` | CodeCompanion | Open chat interface |
| `<leader>ca` | CodeCompanion | Run AI action |
| `<C-g>` | Copilot | Show suggestions |
| `<Tab>` | Copilot | Accept suggestion |
| `<C-]>` | Copilot | Next suggestion |
| `<C-[>` | Copilot | Previous suggestion |

## 🔮 Future Enhancements

### Planned Features
- **Local AI models** via Ollama integration
- **Custom model fine-tuning** for project-specific tasks
- **Team collaboration** features with shared prompts
- **Enhanced security** with local processing options

### Extension Opportunities
- **Language-specific prompts** for different tech stacks
- **Project-aware AI** that understands your codebase structure
- **AI-powered debugging** with automatic error detection
- **Code quality metrics** integrated with AI suggestions

This AI integration transforms Neovim into a powerful AI-assisted development environment while maintaining control over your data and workflow preferences.