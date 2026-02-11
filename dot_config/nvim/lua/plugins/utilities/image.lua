-- Core image.nvim configuration for rendering images in markdown and mermaid
-- Uses Kitty graphics protocol (supported by Ghostty) via tmux passthrough
return {
  "3rd/image.nvim",
  ft = { "markdown", "quarto", "norg" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    backend = "kitty",
    processor = "magick_cli", -- Uses ImageMagick CLI (installed via homebrew)
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        filetypes = { "markdown", "quarto" },
      },
      neorg = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        filetypes = { "norg" },
      },
    },
    max_width = 100,
    max_height = 50,
    max_width_window_percentage = 80,
    max_height_window_percentage = 50,
    window_overlap_clear_enabled = true,
    -- tmux settings
    tmux_show_only_in_active_window = true,
    editor_only_render_when_focused = true,
  },
}
