# Jupyter Notebook Support

This dotfiles repository includes a complete scientific Python environment with interactive Jupyter notebook support directly in Neovim.

## 🚀 Quick Start

1. **Apply dotfiles**: `chezmoi apply`
2. **Start coding**: Create a `.py` or `.ipynb` file
3. **Initialize kernel**: `<leader>mi` to start Python kernel
4. **Execute code**: `<leader>mr` to run current cell/selection

## 📦 What's Included

### Scientific Python Stack
- **Core**: numpy, pandas, matplotlib, seaborn, plotly
- **Machine Learning**: scikit-learn, scipy, statsmodels
- **Jupyter**: jupyter, ipython, ipykernel
- **Development**: black, isort, flake8

All managed via `mise` and automatically installed.

### Neovim Plugins
- **molten.nvim**: Interactive code execution with kernels
- **jupytext.nvim**: Convert between `.py`/`.ipynb` formats
- **image.nvim**: Inline plot rendering in terminal
- **otter.nvim**: LSP support for embedded code blocks

## 🎯 Core Workflows

### 1. Python Script with Jupyter Cells

Create a `.py` file with Jupyter-style cells:

```python
# %%
import numpy as np
import matplotlib.pyplot as plt

# %%
x = np.linspace(0, 2*np.pi, 100)
y = np.sin(x)

plt.figure(figsize=(10, 6))
plt.plot(x, y)
plt.title("Sine Wave")
plt.show()

# %%
# More analysis here...
```

**Usage**:
- `<leader>mi`: Initialize Python kernel
- `<leader>mr`: Run current cell (between `# %%` markers)
- `<leader>mo`: Show kernel output
- `<leader>md`: Delete current cell output

### 2. Working with Notebooks

**Convert formats**:
- `:lua require('jupytext').convert_to_py()`: .ipynb → .py
- `:lua require('jupytext').convert_to_notebook()`: .py → .ipynb

**Interactive editing**:
- Open `.ipynb` files directly in Neovim
- Edit as JSON or convert to `.py` for better version control

### 3. Data Science Workflow

```python
# %%
import pandas as pd
import seaborn as sns

# Load data
df = pd.read_csv('data.csv')
df.head()

# %%
# Quick visualization
sns.scatterplot(data=df, x='feature1', y='feature2', hue='category')
plt.show()

# %%
# Statistical analysis
from scipy import stats
correlation, p_value = stats.pearsonr(df['feature1'], df['feature2'])
print(f"Correlation: {correlation:.3f}, p-value: {p_value:.3f}")
```

## ⌨️ Keybindings

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>mi` | Initialize kernel | Start Python/Julia/R kernel |
| `<leader>mr` | Run cell | Execute current cell or selection |
| `<leader>mo` | Show output | Display kernel output buffer |
| `<leader>md` | Delete output | Clear current cell output |
| `<leader>mh` | Hide output | Hide output for current cell |
| `<leader>ml` | Evaluate line | Run current line |
| `<leader>mv` | Evaluate visual | Run visual selection |
| `<leader>mk` | Interrupt kernel | Stop running execution |
| `<leader>mx` | Restart kernel | Fresh kernel restart |

## 🔧 Configuration

### Python Environment
Configure Python packages in `MISSION_CONTROL/.chezmoidata/mise/python.yaml`:

```yaml
packages:
  - numpy
  - pandas
  - matplotlib
  - your-package-here
```

### Tmux Integration
Required for inline images. Already configured with:
```bash
set -g allow-passthrough "on"
```

### Kernel Management
Molten automatically manages kernels, but you can also:
- `:MoltenEvaluateOperator`: Set up operator for quick execution
- `:MoltenDelete`: Remove all outputs
- `:MoltenInfo`: Show kernel information

## 🎨 Advanced Features

### Inline Plots
Plots automatically render inline when using compatible terminals (Kitty, WezTerm):

```python
# %%
import matplotlib.pyplot as plt
import numpy as np

# This will show inline in your terminal
plt.plot(np.random.randn(100).cumsum())
plt.show()
```

### Multiple Kernels
Run different languages simultaneously:

```python
# Python cell
# %%
import numpy as np
data = np.array([1, 2, 3, 4, 5])
```

```julia
# Julia cell (requires Julia kernel)
# %%
using Statistics
mean(data)  # If data is shared between kernels
```

### LSP Integration
Otter.nvim provides full LSP support for code cells:
- Autocompletion
- Error checking
- Go to definition
- Hover documentation

## 🔍 Troubleshooting

### Common Issues

**1. "No kernel available"**
```bash
# Ensure Python packages are installed
mise install
# Initialize kernel in Neovim
<leader>mi
```

**2. "Images not displaying"**
```bash
# Check tmux passthrough
tmux show-options -g allow-passthrough
# Should show: allow-passthrough on

# Restart tmux if needed
tmux kill-server && tmux
```

**3. "Module not found"**
```bash
# Check mise Python environment
mise which python
mise exec python -- pip list
```

**4. "Kernel died/crashed"**
- `<leader>mx`: Restart kernel
- Check output buffer with `<leader>mo` for error details

### Performance Tips

1. **Large datasets**: Use `df.head()` for initial exploration
2. **Memory management**: Delete unused variables with `del variable`
3. **Plotting**: Set `plt.ioff()` for non-interactive mode when needed

## 📚 Learning Resources

- [Molten.nvim documentation](https://github.com/benlubas/molten-nvim)
- [Jupyter cell format guide](https://jupytext.readthedocs.io/en/latest/formats.html#the-percent-format)
- [Scientific Python tutorials](https://scipy-lectures.org/)

## 🛠️ Customization

### Adding New Kernels
```bash
# Install kernel (example: Julia)
mise use julia@latest
julia -e 'using Pkg; Pkg.add("IJulia")'

# Use in Neovim
:MoltenInit julia
```

### Custom Keybindings
Edit `MISSION_CONTROL/dot_config/nvim/lua/plugins/dev/jupyter.lua` to customize keybindings.

### Additional Python Packages
Add to `MISSION_CONTROL/.chezmoidata/mise/python.yaml` and run `chezmoi apply`.