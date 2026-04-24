return {
  {
    "Aevox121/four-claude.nvim",
    main = "four-claude",
    config = function()
      require("four-claude").setup({
        agents = {
          claude   = { cmd = "claude" },
          opencode = { cmd = "opencode" },
          codex    = { cmd = "codex" },
        },
        default_agent = "claude",
        alert = {
          enabled = true,
          delay = 5000,
          interval = 2000,
        },
      })
    end,
    keys = {
      { "<leader>C",  "<cmd>FourClaudeToggle<cr>",          desc = "Toggle 4 Claude windows" },
      { "<leader>cO", "<cmd>FourClaudeToggle opencode<cr>", desc = "Toggle 4 opencode windows" },
      { "<leader>cX", "<cmd>FourClaudeToggle codex<cr>",    desc = "Toggle 4 codex windows" },
      { "<leader>cp", "<cmd>FourClaudePin<cr>",             desc = "Pin/unpin Claude pane to sidebar" },
    },
  },
}
