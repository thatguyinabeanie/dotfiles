-- Override LazyVim's chezmoi notifications to be less chatty
return {
  "xvzc/chezmoi.nvim",
  opts = {
    events = {
      on_open = {
        notification = {
          enable = false,
        },
      },
      on_watch = {
        notification = {
          enable = false,
        },
      },
      on_apply = {
        notification = {
          enable = true,
          msg = "Successfully applied",
          opts = {},
        },
      },
    },
  },
}
