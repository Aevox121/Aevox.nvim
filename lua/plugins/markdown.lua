return {
  -- Markdown 渲染美化（在编辑器内直接渲染）
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-mini/mini.nvim", -- 图标支持
    },
    ft = "markdown",
    opts = {},
  },

  -- Markdown 语法解析器
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "markdown", "markdown_inline" },
    },
  },

  -- Markdown 禁用自动补全（含菜单与 ghost text 建议）
  {
    "saghen/blink.cmp",
    opts = {
      enabled = function()
        return vim.bo.filetype ~= "markdown"
      end,
    },
  },
}
