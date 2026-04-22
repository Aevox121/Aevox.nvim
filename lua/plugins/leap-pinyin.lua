return {
  -- 禁用 LazyVim 默认 flash.nvim 的 s/S 键，让 leap-pinyin 接管
  {
    "folke/flash.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, false },
      { "S", mode = { "n", "x", "o" }, false },
    },
  },

  {
    "Aevox121/leap-pinyin.nvim",
    name = "leap-pinyin",
    event = "VeryLazy",
    config = function()
      require("leap-pinyin").setup({
        mode = "shuangpin", -- 小鹤双拼
      })
      -- 禁用 autojump：所有匹配位置都显示 label，不自动跳到第一个
      require("leap").opts.safe_labels = ""
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-pinyin-forward)",
        { silent = true, desc = "Leap shuangpin forward" })
      vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-pinyin-backward)",
        { silent = true, desc = "Leap shuangpin backward" })
    end,
  },
}
