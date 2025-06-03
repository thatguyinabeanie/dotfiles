# Development Tools Configuration

This directory contains configurations for development tools in Neovim.

## Neotest Configuration

The `neotest.lua` file configures test runners for multiple languages:

### JavaScript/TypeScript
- **Jest**: Automatically detected via `jest.config.*` files or package.json
- **Vitest**: Automatically detected via `vitest.config.*` or `vite.config.*` files
- Package manager detection: npm, yarn, pnpm, bun, deno

### Ruby
- **RSpec**: Automatically detected via `Gemfile`, `.rspec`, or `spec/spec_helper.rb`
- Uses `bundle exec rspec` for running tests

### Python
- **Pytest**: Default test runner (configurable to unittest)
- Automatically detected via `setup.py`, `pyproject.toml`, `requirements.txt`, etc.
- Looks for virtual environments in common locations

### Key Mappings
- `<leader>tr` - Run nearest test
- `<leader>tf` - Run test file
- `<leader>ta` - Run all tests
- `<leader>tl` - Run last test
- `<leader>td` - Debug nearest test
- `<leader>to` - Show test output
- `<leader>ts` - Toggle test summary
- `<leader>tw` - Run tests in watch mode (JS/TS)
- `[t` / `]t` - Navigate to previous/next failed test

## Overseer Configuration

The `overseer.lua` file provides task running capabilities:

### JavaScript/TypeScript Tasks
- npm/pnpm/yarn/bun install
- npm/pnpm/yarn/bun run dev
- deno run

### Ruby/Rails Tasks
- bundle install
- rails server
- rails console

### Python Tasks
- python run (current file)
- pip install requirements
- django runserver

### Key Mappings
- `<leader>or` - Run task
- `<leader>ot` - Toggle task list
- `<leader>ob` - Build task
- `<leader>oq` - Quick action
- `<leader>oa` - Task action
- `<leader>oi` - Task info

## DAP (Debug Adapter Protocol) Configuration

The `nvim-dap.lua` file configures debugging for multiple languages:

### JavaScript/TypeScript
- Node.js debugging
- Chrome/Edge debugging for web apps
- Jest test debugging
- Vitest test debugging

### Ruby
- Ruby debugging via ruby-debug-ide

### Python
- Python debugging via debugpy
- Django application debugging
- FastAPI application debugging

### Key Mappings
- `<F5>` - Start/Continue debugging
- `<F10>` - Step over
- `<F11>` - Step into
- `<F12>` - Step out
- `<leader>db` - Toggle breakpoint
- `<leader>dB` - Set conditional breakpoint
- `<leader>du` - Toggle debug UI
- `<leader>de` - Evaluate expression under cursor
- `<leader>dt` - Terminate debugging session

## Integration

All these tools work together:
- Overseer can run build tasks before tests
- Neotest can debug tests using DAP
- DAP integrates with Overseer for task-based debugging