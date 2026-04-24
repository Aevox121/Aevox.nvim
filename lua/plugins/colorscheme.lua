return {
  -- handcrafted Claude-web-inspired theme (T-0079), local dev path
  { "Aevox121/claudecolor.nvim", lazy = false, priority = 1000 },

  -- melange kept as fallback while claudecolor iterates
  { "savq/melange-nvim", name = "melange" },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "claudecolor-light",
    },
  },
}
