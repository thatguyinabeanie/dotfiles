return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "RRethy/nvim-treesitter-endwise" },
    endwise = { enable = true },
    auto_install = true,

    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      vim.treesitter.language.register("lua", "lua.tmpl")
      vim.treesitter.language.register("toml", "toml.tmpl")
    end,

    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",

        "cmake",
        "comment",
        "csv",

        "diff",
        "dockerfile",
        "dot",

        "embedded_template",
        "elixir",

        "git_config",
        "gitignore",
        "gleam",
        "gpg",
        "graphql",
        "html",

        "html",

        "java",
        "javascript",
        "json",
        "jq",

        "kotlin",

        "llvm",

        "lua",
        "luadoc",
        "latex",

        "markdown",
        "markdown_inline",

        "nu",
        "nix",
        "nginx",
        "norg",

        "python",
        "proto",

        "query",

        "readline",
        "r",
        "regex",
        "rust",
        "ruby",

        "ssh_config",
        "swift",
        "svelte",
        "superhtml",
        "ssh_config",
        "sql",
        "scss",
        "scala",

        "toml",
        "tsx",
        "typescript",
        "tmux",
        "typst",
        "terraform",
        "templ",

        "vim",
        "vimdoc",

        "xml",

        "yaml",

        "zig",
      })
    end,
  },
}
