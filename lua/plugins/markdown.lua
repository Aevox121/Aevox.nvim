-- Markdown 编辑插件配置（修复预览插件报错）
return {
  -- 1. 核心 Markdown 语法增强（表格、列表、链接等功能）
  {
    "preservim/vim-markdown",
    dependencies = {
      "godlygeek/tabular", -- 表格格式化依赖
    },
    ft = "markdown", -- 仅在 Markdown 文件中生效
    config = function()
      -- 基础配置（用 vim.g 设置全局变量，适配传统 Vim 插件）
      vim.g.vim_markdown_gfm = 1 -- 支持 GitHub Flavored Markdown (GFM)
      vim.g.vim_markdown_tables = 1 -- 启用表格功能
      vim.g.vim_markdown_fenced_code_blocks = 1 -- 支持代码块（``` 包裹）
      vim.g.vim_markdown_auto_insert_bullets = 1 -- 列表回车自动补全 bullet（-/*）
      vim.g.vim_markdown_conceal = 1 -- 隐藏 Markdown 语法符号（#/*，鼠标悬浮显示）
      vim.g.vim_markdown_math = 1 -- 可选：启用 LaTeX 公式支持（需浏览器 MathJax 扩展）

      -- 快捷键配置（仅在 Markdown 文件中生效）
      local opts = { noremap = true, silent = true, buffer = true }
      -- 表格格式化：选中表格后按 <leader>mt
      vim.keymap.set("v", "<leader>mt", "<Plug>Markdown_TableFormat", opts)
      -- 插入链接：光标在文字上按 <leader>ml
      vim.keymap.set("n", "<leader>ml", "<Plug>Markdown_InsertLink", opts)
      -- 插入图片：按 <leader>mi
      vim.keymap.set("n", "<leader>mi", "<Plug>Markdown_InsertImage", opts)
    end,
  },

  -- 2. 实时浏览器预览（修复配置方式，改用 config() 函数）
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function()
      -- 安装插件时自动编译预览服务（Windows 适配）
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      -- 用 vim.g 设置预览插件的全局变量（核心修复）
      vim.g.mkdp_auto_start = 0 -- 打开文件不自动启动预览
      vim.g.mkdp_auto_close = 1 -- 关闭文件自动关闭预览
      vim.g.mkdp_refresh_slow = 1 -- 慢刷新（避免频繁卡顿）
      vim.g.mkdp_browser = "default" -- 使用系统默认浏览器
      vim.g.mkdp_echo_preview_url = 1 -- 预览启动后，在终端显示预览地址
      vim.g.mkdp_open_to_the_world = 0 -- 不允许局域网访问（安全）
      vim.g.mkdp_port = "" -- 自动分配端口（避免端口冲突）

      -- 快捷键：按 <leader>mp 启动/关闭预览（仅在 Markdown 文件中生效）
      local opts = { noremap = true, silent = true, buffer = true }
      vim.keymap.set("n", "<leader>mp", "<Plug>MarkdownPreviewToggle", opts)
    end,
  },

  -- 3. 增强 Markdown 语法高亮（基于 nvim-treesitter）
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "markdown", "markdown_inline" }, -- 安装 Markdown 语法解析器
    },
  },
}
