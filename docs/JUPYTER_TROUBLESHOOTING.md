# Jupyter & Scientific Python Troubleshooting

Common issues and solutions for the Jupyter notebook setup in this dotfiles configuration.

## 🚨 Kernel Issues

### "No kernel available" or "Failed to start kernel"

**Symptoms**: Error when running `<leader>mi` or executing cells
**Solutions**:

```bash
# 1. Check mise Python installation
mise install python
mise which python

# 2. Verify scientific packages are installed
mise exec python -- pip list | grep -E "(jupyter|numpy|matplotlib)"

# 3. Reinstall Python packages
mise exec python -- pip install --upgrade jupyter ipython ipykernel

# 4. Test kernel directly
mise exec python -- python -m ipykernel_launcher
```

### Kernel dies immediately

**Check kernel logs**:
```vim
:MoltenInfo  " Shows kernel status and errors
:messages    " Check Neovim error messages
```

**Common fixes**:
- Restart Neovim completely
- Check for Python import errors in the output buffer (`<leader>mo`)
- Ensure no conflicting Python installations

## 🖼️ Image Display Issues

### "tmux does not have allow-passthrough enabled"

**Quick fix**:
```bash
# Enable passthrough in current session
tmux set-option -g allow-passthrough on

# Restart tmux completely
tmux kill-server && tmux
```

**Permanent fix**: The configuration should already include this, but verify:
```bash
grep "allow-passthrough" ~/.config/tmux/tmux.conf
# Should show: set -g allow-passthrough "on"
```

### Images not displaying in terminal

**Check terminal compatibility**:
- ✅ **Kitty**: Full support
- ✅ **WezTerm**: Good support  
- ❌ **iTerm2**: Limited support
- ❌ **Standard Terminal**: No support

**Test image display**:
```python
# %%
import matplotlib.pyplot as plt
plt.plot([1, 2, 3, 4])
plt.title("Test Plot")
plt.show()
```

**Alternative solutions**:
- Use `plt.savefig('plot.png')` and open externally
- Switch to a compatible terminal emulator
- Disable image.nvim temporarily in plugin config

## 📦 Package Installation Issues

### ImportError: No module named 'package_name'

**Check mise Python environment**:
```bash
# Verify which Python is being used
mise which python

# Check if running in correct environment
mise exec python -- python -c "import sys; print(sys.executable)"
```

**Install missing packages**:
```yaml
# Add to MISSION_CONTROL/.chezmoidata/mise/python.yaml
packages:
  - your-missing-package
```

```bash
# Apply changes
chezmoi apply
```

### Package version conflicts

**Reset Python environment**:
```bash
# Uninstall and reinstall Python
mise uninstall python
mise install python

# Reapply dotfiles to reinstall packages
chezmoi apply
```

## 🔧 Neovim Plugin Issues

### Molten.nvim not loading

**Check plugin installation**:
```vim
:Lazy  " Open plugin manager
# Find molten.nvim and check for errors
```

**Common solutions**:
```bash
# Update plugins
nvim --headless -c "Lazy! sync" -c "q"

# Check for Lua errors
nvim --headless -c "lua require('molten')" -c "q"
```

### Jupytext conversion errors

**Manual conversion**:
```bash
# Install jupytext globally
mise exec python -- pip install jupytext

# Convert manually
mise exec python -- jupytext --to py notebook.ipynb
mise exec python -- jupytext --to ipynb script.py
```

## ⚡ Performance Issues

### Slow kernel startup

**Check system resources**:
```bash
# Monitor system load
btop

# Check available memory
free -h  # Command to check available memory on Linux
vm_stat  # Command to check available memory on macOS
```

**Solutions**:
- Close other applications
- Restart kernel: `<leader>mx`
- Use smaller datasets for testing

### High memory usage

**Memory management**:
```python
# %%
# Clear large variables
del large_dataframe
del model

# Garbage collection
import gc
gc.collect()

# Check memory usage
import psutil
print(f"Memory usage: {psutil.virtual_memory().percent}%")
```

## 🔍 Debugging Steps

### Step 1: Basic functionality check

```python
# %%
print("Hello from Jupyter kernel!")
import sys
print(f"Python: {sys.version}")
print(f"Executable: {sys.executable}")
```

### Step 2: Package availability

```python
# %%
try:
    import numpy as np
    import pandas as pd
    import matplotlib.pyplot as plt
    print("✅ Core packages imported successfully")
except ImportError as e:
    print(f"❌ Import error: {e}")
```

### Step 3: Plotting test

```python
# %%
import matplotlib.pyplot as plt
import numpy as np

x = np.linspace(0, 10, 100)
plt.plot(x, np.sin(x))
plt.title("Test Plot")
plt.show()
```

## 📋 Environment Information

### Collect debug info

```python
# %%
import sys, os, subprocess

print("=== Environment Debug Info ===")
print(f"Python executable: {sys.executable}")
print(f"Python version: {sys.version}")
print(f"Working directory: {os.getcwd()}")

try:
    result = subprocess.run(['mise', 'which', 'python'], 
                          capture_output=True, text=True)
    print(f"Mise Python: {result.stdout.strip()}")
except:
    print("Could not run mise command")

print("\n=== Installed Packages ===")
try:
    import pkg_resources
    packages = [f"{pkg.key}=={pkg.version}" 
               for pkg in pkg_resources.working_set]
    for pkg in sorted(packages)[:10]:  # Show first 10
        print(pkg)
except:
    print("Could not list packages")
```

## 🆘 Getting Help

### Check logs and status

```vim
" Neovim commands for debugging
:checkhealth molten      " Check molten.nvim health
:messages                " Show error messages  
:MoltenInfo              " Kernel status
```

```bash
# System-level debugging
mise doctor              # Check mise installation
tmux show-options -g     # Check tmux settings
chezmoi doctor          # Check chezmoi status
```

### Common error patterns

| Error Message | Likely Cause | Solution |
|---------------|--------------|----------|
| "No such file or directory: python" | Missing Python installation | `mise install python` |
| "Kernel died" | Python import error | Check packages, restart kernel |
| "tmux passthrough" | Terminal configuration | Enable tmux passthrough |
| "Module not found" | Missing package | Add to mise python.yaml |
| "Connection refused" | Kernel communication issue | Restart Neovim, check firewall |

### Recovery commands

```bash
# Nuclear option: reset everything
mise uninstall python
mise install python
chezmoi apply
tmux kill-server && tmux
```

If issues persist, check the [main Jupyter documentation](JUPYTER.md) or create an issue in the dotfiles repository with your debug information.