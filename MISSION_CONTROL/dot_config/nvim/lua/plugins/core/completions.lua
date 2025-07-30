return {
  "saghen/blink.cmp",
  build = false, -- Use prebuilt binaries for faster installation and better stability
  version = "v0.*", -- Use stable releases with prebuilt binaries
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  opts = {
    fuzzy = {
      implementation = "prefer_rust",
      use_frecency = true,
      use_proximity = true,
      prebuilt_binaries = {
        download = true,
        force_version = nil,
      },
    },
  },
}

