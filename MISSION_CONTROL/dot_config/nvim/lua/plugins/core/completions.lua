return {
  "saghen/blink.cmp",
  build = false, -- Use prebuilt binaries to avoid Rust compiler bug
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

