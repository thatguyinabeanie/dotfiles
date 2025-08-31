---@diagnostic disable: undefined-global

-- Luacheck configuration for Neovim dotfiles
std = "lua54"

-- Neovim globals
globals = {
	"vim",
	"Snacks",
}

-- Yazi plugin globals (for files in yazi/plugins/)
files["dot_config/yazi/plugins/**"] = {
	globals = {
		"ya",
		"fs",
		"Command",
		"job",
	},
}



-- Ignore specific warnings
ignore = {
	"631", -- line too long
	"212", -- unused argument (for yazi plugin methods)
}

-- Files to exclude
exclude_files = {
	"**/node_modules/**",
	"**/.git/**",
	"**/*.tmpl",
}
