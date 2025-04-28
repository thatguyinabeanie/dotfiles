-- automatically save and restore sessions
-- https://github.com/rmagatti/auto-session

return {
  {
    "rmagatti/auto-session",
    lazy = false,
    opts = {
      suppressed_dirs = {
        "~/",
        "~/Projects",
        "~/Downloads",
        "~/Documents",
        "~/Music",
        "~/Pictures",
        "~/Public",
        "/",
      },
    },
  },
}
