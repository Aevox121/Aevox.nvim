-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- 删掉 LazyVim 的 wrap_spell 组：原版会在 markdown/text/tex 里同时开 wrap + spell，
-- 中文/中英混排下 spell 会到处标红波浪线，太吵。下面手动只开 wrap，不开 spell。
vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

-- Force-start treesitter highlighting on markdown buffers.
-- nvim-treesitter main branch's get_installed("parsers") doesn't see the markdown
-- parser, so LazyVim's FileType autocmd skips vim.treesitter.start. Parser is
-- usable (vim.treesitter.start works manually), so we just call it ourselves.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})
