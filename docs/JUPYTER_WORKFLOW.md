# Neovim Jupyter Workflow Reference

Quick reference for using Jupyter notebooks and scientific Python within Neovim.

## 🚀 Essential Keybindings

| Key | Action | Context |
|-----|--------|---------|
| `<leader>mi` | **Initialize kernel** | Start Python/Julia/R kernel |
| `<leader>mr` | **Run cell/selection** | Execute current cell or visual selection |
| `<leader>mo` | **Show output** | Display kernel output buffer |
| `<leader>md` | **Delete output** | Clear current cell output |
| `<leader>mh` | **Hide output** | Hide output for current cell |
| `<leader>ml` | **Evaluate line** | Run current line only |
| `<leader>mv` | **Evaluate visual** | Run visual selection |
| `<leader>mk` | **Interrupt kernel** | Stop running execution |
| `<leader>mx` | **Restart kernel** | Fresh kernel restart |

## 📝 Cell Formats

### Python Script with Jupyter Cells
```python
# %%
import numpy as np
import matplotlib.pyplot as plt

# %%
# This is a cell - run with <leader>mr
x = np.linspace(0, 2*np.pi, 100)
y = np.sin(x)

plt.figure(figsize=(10, 6))
plt.plot(x, y, label='sin(x)')
plt.legend()
plt.show()

# %%
# Another cell
print(f"Data points: {len(x)}")
print(f"Max value: {y.max():.3f}")
```

### Markdown Cells (in .md files)
````markdown
```python
# Code block that can be executed
import pandas as pd
df = pd.DataFrame({'x': [1, 2, 3], 'y': [4, 5, 6]})
df.head()
```
````

## 🔄 File Format Conversion

Convert between formats using jupytext.nvim:

```lua
-- Convert .ipynb to .py
:lua require('jupytext').convert_to_py()

-- Convert .py to .ipynb  
:lua require('jupytext').convert_to_notebook()

-- Sync paired files
:lua require('jupytext').sync()
```

## 🎯 Workflow Examples

### 1. Data Analysis Session
```python
# %%
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Load and explore data
df = pd.read_csv('data.csv')
df.info()

# %%
# Quick visualization
plt.figure(figsize=(12, 8))
sns.pairplot(df, hue='category')
plt.show()

# %%
# Statistical summary
df.describe()
```

### 2. Machine Learning Pipeline
```python
# %%
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report

# Prepare data
X = df.drop('target', axis=1)
y = df['target']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

# %%
# Train model
model = RandomForestClassifier(n_estimators=100)
model.fit(X_train, y_train)

# %%
# Evaluate
y_pred = model.predict(X_test)
print(classification_report(y_test, y_pred))
```

### 3. Interactive Plotting
```python
# %%
import plotly.express as px
import plotly.graph_objects as go

# Interactive scatter plot
fig = px.scatter(df, x='feature1', y='feature2', 
                color='category', size='value',
                hover_data=['extra_info'])
fig.show()

# %%
# Custom plotly figure
fig = go.Figure()
fig.add_trace(go.Scatter(x=x, y=y, mode='lines+markers'))
fig.update_layout(title='Custom Plot', 
                  xaxis_title='X Values',
                  yaxis_title='Y Values')
fig.show()
```

## 🔧 Advanced Commands

### Kernel Management
```vim
:MoltenInfo                    " Show kernel info
:MoltenDelete                  " Delete all outputs  
:MoltenInterrupt               " Interrupt kernel
:MoltenRestart                 " Restart kernel
:MoltenEvaluateOperator        " Set up operator mode
:MoltenHideOutput              " Hide all outputs
:MoltenShowOutput              " Show all outputs
```

### Output Management
```vim
:MoltenNext                    " Go to next output
:MoltenPrev                    " Go to previous output
:MoltenEnterOutput             " Enter output buffer
:MoltenSave                    " Save outputs to file
:MoltenLoad                    " Load outputs from file
```

## 🎨 Visual Mode Operations

Select code and run with `<leader>mv`:

```python
# Select these lines and run with <leader>mv
import numpy as np
x = np.array([1, 2, 3, 4, 5])
print(f"Mean: {x.mean()}")
```

## 🐍 Python Environment

All scientific packages managed via mise:

```bash
# Check installed packages
mise exec python -- pip list

# Add new package
echo "  - your-package" >> MISSION_CONTROL/.chezmoidata/mise/python.yaml
chezmoi apply
```

## 🖼️ Image Display

Images automatically render inline with compatible terminals:

```python
# %%
import matplotlib.pyplot as plt
import numpy as np

# This will display inline
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 5))

ax1.plot(np.random.randn(100).cumsum())
ax1.set_title('Random Walk')

ax2.hist(np.random.normal(0, 1, 1000), bins=30)
ax2.set_title('Normal Distribution')

plt.tight_layout()
plt.show()  # Renders directly in terminal!
```

## ⚡ Performance Tips

1. **Use `plt.ioff()`** for non-interactive plotting when generating many plots
2. **Clear variables** with `del variable` to free memory
3. **Use `df.head()`** for initial data exploration
4. **Restart kernel** (`<leader>mx`) if memory usage gets high

## 🔍 Debugging

### Check Kernel Status
```python
# %%
import sys
print(f"Python version: {sys.version}")
print(f"Executable: {sys.executable}")

# Check if in Jupyter context
try:
    import ipykernel
    print("Running in Jupyter kernel")
except ImportError:
    print("Not in Jupyter kernel")
```

### Common Issues
- **Kernel won't start**: Check mise Python installation
- **Images not showing**: Verify tmux passthrough enabled
- **Import errors**: Check if package installed in mise environment
- **Memory issues**: Restart kernel with `<leader>mx`

## 📚 Learning Resources

- [Molten.nvim docs](https://github.com/benlubas/molten-nvim/blob/main/docs/Functionality.md)
- [Jupyter cell format](https://jupytext.readthedocs.io/en/latest/formats.html#the-percent-format)
- [Scientific Python ecosystem](https://scipy.org/)

Happy scientific computing 🚀