# Jupyter Notebook Support in Neovim

This configuration adds comprehensive Jupyter notebook support to your Neovim setup, transforming it into a powerful physics and data science IDE.

## Features

### 🔥 **Molten.nvim - Interactive Execution**
- Real-time code execution with Jupyter kernels
- Inline plots and visualizations via image.nvim
- Virtual text output display (clean, Jupyter-like experience)
- Multiple kernel support (Python, Julia, R)
- Save/load notebook state

### 📝 **Jupytext.nvim - File Format Conversion**
- Edit .ipynb files as clean Python/Markdown
- Automatic synchronization between formats
- Git-friendly workflow (version control .py files)
- Support for multiple output formats (py:percent, markdown, quarto)

### 🖼️ **Image.nvim - Visualization Support**
- Inline image rendering in terminal (Kitty/Ghostty compatible)
- Matplotlib, Plotly, and other plot libraries supported
- Optimized for your tmux workflow

### 🧠 **Otter.nvim - LSP Integration**
- Full LSP support for embedded code blocks
- Autocompletion and diagnostics in notebook cells
- Works with your existing LSP setup

## Installation

The plugins will be automatically installed via Lazy.nvim. Python dependencies are managed through mise:

```bash
# Install Python packages via mise configuration
mise install

# Update Neovim remote plugins (required for Molten)
nvim --headless -c "UpdateRemotePlugins" -c "qa"

# Restart tmux to enable passthrough (required for image support)
tmux kill-server && tmux
```

**Image Support**: Now fully enabled with tmux passthrough support. Images from matplotlib, plotly, and other libraries will render inline in your terminal.

## Troubleshooting

### If kernels don't start:
1. Check Python environment: `:MoltenInfo`
2. Verify pynvim installation: `python -c "import pynvim"`
3. Update remote plugins: `:UpdateRemotePlugins`
4. Restart Neovim after plugin installation

### If images don't display:
1. Check if tmux passthrough is enabled: `tmux show-options -g allow-passthrough`
2. Restart tmux session: `tmux kill-server && tmux`
3. Verify terminal compatibility: Should work with Ghostty/Kitty
4. Check image.nvim status: `:checkhealth image`

### If you see luarocks errors:
1. Install lua 5.1: `mise install lua@5.1.5`
2. Restart Neovim to rebuild luarocks dependencies
3. The configuration will gracefully fallback if image support fails

### Performance issues:
1. Reduce output limits in configuration
2. Use floating windows instead of virtual text if needed
3. Clear outputs regularly with `<leader>mc`

## Advanced Usage

### Custom Kernel Initialization
```lua
-- Auto-detect conda/virtualenv and initialize appropriate kernel
vim.keymap.set("n", "<leader>ma", function()
  local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
  if venv then
    local kernel_name = string.match(venv, "/.+/(.+)")
    vim.cmd(("MoltenInit %s"):format(kernel_name))
  else
    vim.cmd("MoltenInit python3")
  end
end)
```

### Integration with Obsidian
The setup integrates with your existing Obsidian workflow for research documentation and note-taking.

This transforms your Neovim into a **physics research powerhouse** with Jupyter-level interactivity! 🚀