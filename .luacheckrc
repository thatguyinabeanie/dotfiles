-- Luacheck configuration for Neovim dotfiles
std = "lua54"

-- Neovim globals
globals = {
	"vim",
	"Snacks",
}

-- Ignore specific warnings
ignore = {
	"631", -- line too long
}

-- Files to exclude
exclude_files = {
	"**/node_modules/**",
	"**/.git/**",
}
