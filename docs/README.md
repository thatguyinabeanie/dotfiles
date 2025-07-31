# Documentation Index

Comprehensive guide to all documentation available in this dotfiles repository.

## 📚 Core Documentation

### **[README.md](../README.md)**

Main entry point with installation instructions, feature overview, and quick start guide.

### **[AGENTS.md](../AGENTS.md)**

Essential guidance for AI coding agents working with this repository.

## 🔧 System Configuration

### **[TEMPLATE_SYSTEM.md](TEMPLATE_SYSTEM.md)**

**Critical**: Understanding the Chezmoi template system that powers dynamic configuration.

- Interactive vs non-interactive modes
- Environment detection (Codespaces, CI/CD)
- Configuration variable management
- Template troubleshooting

### **[MISE_INTEGRATION.md](MISE_INTEGRATION.md)**

Complete guide to the mise-based dependency management system.

- Language version management
- Automatic environment setup
- Python package management
- Hook system and automation

## 🚀 Development Tools

### **[JUPYTER.md](JUPYTER.md)**

Comprehensive Jupyter notebook support for scientific computing.

- Setup and configuration
- Interactive code execution
- Inline plotting and visualization
- Package management and troubleshooting

### **[JUPYTER_WORKFLOW.md](JUPYTER_WORKFLOW.md)**

Quick reference for Jupyter workflows and keybindings.

- Essential keybindings
- Common workflows (data science, ML)
- Code examples and best practices

### **[JUPYTER_TROUBLESHOOTING.md](JUPYTER_TROUBLESHOOTING.md)**

Solutions for common Jupyter setup and usage issues.

- Kernel problems
- Image display issues
- Package installation
- Performance optimization

### **[NEOVIM_AI.md](NEOVIM_AI.md)**

AI-powered development tools integrated into Neovim.

- Avante.nvim (Claude integration)
- CodeCompanion (multi-provider chat)
- GitHub Copilot setup
- MCP hub integration

## 🐚 Shell & Terminal

### **[SHELL_FUNCTIONS.md](SHELL_FUNCTIONS.md)**

Reference for advanced shell functions in both Zsh and Nushell.

- Git & GitHub automation
- Docker management (with safety features)
- Spotify controls (macOS)
- Obsidian vault switching
- System utilities

## 🧪 Quality & Testing

### **[TESTING.md](TESTING.md)**

Testing infrastructure and CI/CD workflows.

- Unit and integration tests
- GitHub Actions workflows
- Coverage requirements
- Performance testing
- Local development guidelines

## 📖 Additional Resources

### **Application-Specific Documentation**

- **[Obsidian README](../MISSION_CONTROL/obsidian/README.md)** - Knowledge management setup
- **[Neovim Configuration](../MISSION_CONTROL/dot_config/nvim/README.md)** - Editor configuration details
- **[Git Configuration](../MISSION_CONTROL/dot_config/git/README.md)** - Version control setup

### **Component Documentation**

- **[Homebrew Management](../scripts/)** - Package management scripts
- **[Testing Helpers](../_tests_/.README.md)** - Test utilities and patterns

## 🎯 Quick Navigation

### **New User Start Here**

1. **[README.md](../README.md)** - Installation and overview
2. **[TEMPLATE_SYSTEM.md](TEMPLATE_SYSTEM.md)** - Understanding configuration
3. **[SHELL_FUNCTIONS.md](SHELL_FUNCTIONS.md)** - Available commands

### **Development Setup**

1. **[MISE_INTEGRATION.md](MISE_INTEGRATION.md)** - Development environment
2. **[JUPYTER.md](JUPYTER.md)** - Scientific computing (if needed)
3. **[NEOVIM_AI.md](NEOVIM_AI.md)** - AI-assisted development

### **Advanced Usage**

1. **[TESTING.md](TESTING.md)** - Contributing and testing
3. **[AGENTS.md](../AGENTS.md)** - AI agent integration

## 🔍 Documentation Standards

### **File Naming Conventions**

- **UPPERCASE.md** - Major system documentation
- **lowercase.md** - Component-specific guides
- **Component_Name.md** - Application documentation

### **Structure Guidelines**

- **🎯 Purpose** - What this document covers
- **🏗️ Architecture** - How it works
- **⚙️ Configuration** - Setup details
- **🚀 Usage** - Practical examples
- **🔧 Troubleshooting** - Common issues
- **📚 References** - Related documentation

### **Content Principles**

- **Beginner-friendly** - Assume no prior knowledge
- **Practical examples** - Always include usage examples
- **Visual organization** - Use emojis and headers for easy scanning
- **Cross-references** - Link to related documentation
- **Keep current** - Update documentation with changes

## 🛠️ Contributing to Documentation

### **Adding New Documentation**

1. Create file in appropriate directory (`docs/` for major topics)
2. Follow naming conventions and structure guidelines
3. Add entry to this index
4. Update related documentation with cross-references
5. Test all examples and commands

### **Updating Existing Documentation**

1. Maintain backward compatibility in examples
2. Update cross-references if structure changes
3. Validate all links and commands still work
4. Consider impact on dependent documentation

### **Documentation Review Checklist**

- [ ] Clear purpose and scope defined
- [ ] Practical examples included
- [ ] All commands tested and working
- [ ] Cross-references updated
- [ ] Follows house style (emojis, structure)
- [ ] Accessible to intended audience

This documentation system ensures that every aspect of the dotfiles configuration is well-documented and accessible to users at all skill levels.
