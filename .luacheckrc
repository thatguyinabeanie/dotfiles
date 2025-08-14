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

-- SketchyBar globals (for files in sketchybar/)
files["**/sketchybar/**"] = {
	globals = {
		"sbar",
		"id",
		"current",
	},
	ignore = {
		"211", -- unused variable
		"212", -- unused argument
		"213", -- unused loop variable
		"311", -- value assigned to variable is unused
		"421", -- shadowing definition of variable
		"431", -- shadowing upvalue
		"581", -- can use ~= instead of not ==
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
}
