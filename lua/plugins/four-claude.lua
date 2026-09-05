return {
  {
    "Aevox121/four-claude.nvim",
    main = "four-claude",
    config = function()
      require("four-claude").setup({
        agents = {
          claude   = { cmd = "claude --dangerously-skip-permissions" },
          opencode = { cmd = "opencode" },
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
      { "<leader>cX", "<cmd>FourCodexToggle<cr>",          desc = "Toggle 4 Codex windows" },
      { "<leader>cp", "<cmd>FourClaudePin<cr>",             desc = "Pin/unpin Claude pane to sidebar" },
    },
  },
}
