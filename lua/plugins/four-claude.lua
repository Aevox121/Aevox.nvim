return {
  {
    "Aevox121/four-claude.nvim",
    config = function()
      require("four-claude").setup({
        cmd = "claude",
        alert = {
          enabled = true,
          delay = 5000,
          interval = 2000,
        },
      })
    end,
    keys = {
      { "<leader>C", "<cmd>FourClaudeToggle<cr>", desc = "Toggle 4 Claude windows" },
    },
  },
}
