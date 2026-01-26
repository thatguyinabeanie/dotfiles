-- Core image.nvim configuration for general image display
-- Used by various plugins like molten-nvim, quarto, etc.
-- Disabled: requires luarocks and kitty graphics protocol
-- Notebooks plugins are also disabled, so this is not needed
if true then
  return {}
end

return {
  "3rd/image.nvim",
  lazy = true,
  opts = {
    backend = "kitty",
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        filetypes = { "markdown", "quarto" },
      },
      neorg = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        filetypes = { "norg" },
      },
    },
    max_width = 25,
    max_height = 12,
    max_width_window_percentage = 100,
    max_height_window_percentage = 100,
  },
}
