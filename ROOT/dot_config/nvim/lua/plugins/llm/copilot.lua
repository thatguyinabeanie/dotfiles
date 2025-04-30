return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      copilot_node_command = os.getenv("HOME") .. "/.local/share/mise/installs/node/22/bin/node",
      workspace_folders = {
        os.getenv("HOME") .. "source",
      },
    },
  },
}
