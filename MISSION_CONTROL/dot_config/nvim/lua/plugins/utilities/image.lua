-- Image rendering support for plots, visualizations, and markdown
return {
  "3rd/image.nvim",
  event = "VeryLazy",
  dependencies = {
    {
      "vhyrro/luarocks.nvim",
      priority = 1001, -- this plugin needs to run before anything else
      opts = {
        rocks = { "magick" },
      },
    },
  },
  opts = {
    backend = "kitty", -- Works with both Kitty and Ghostty
    processor = "magick_rock", -- Use magick rock processor
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        filetypes = { "markdown", "vimwiki" },
      },
      neorg = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        filetypes = { "norg" },
      },
      html = {
        enabled = false,
      },
      css = {
        enabled = false,
      },
    },
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = 50,
    max_height_window_percentage = 50,
    window_overlap_clear_enabled = true, -- Clear images when they overlap windows
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    editor_only_render_when_focused = false,
    tmux_show_only_in_active_window = true, -- Important for tmux users
  },
}