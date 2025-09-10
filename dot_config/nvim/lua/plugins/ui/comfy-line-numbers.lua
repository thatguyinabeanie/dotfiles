-- Comfortable line numbers with smooth transitions
return {
  "shortcuts/no-neck-pain.nvim",
  enabled = false,
},
{
  "lukas-reineke/virt-column.nvim",
  enabled = false,
},
{
  "rachartier/tiny-inline-diagnostic.nvim",
  enabled = false,
},
{
  "ragnarok22/whereami.nvim",
  enabled = false,
},
{
  "comfysage/comfy-line-numbers.nvim",
  event = "VeryLazy",
  opts = {
    enable_powersave = true,
    powersave_delay = 3000,
    enable_soft_wrap_at_start = true,
  },
}