return {
  -- LazyVim 已按需启用 mini.ai / mini.icons / mini.pairs，这里只覆写 mini.ai 的 opts。
  -- 之前还装了 `mini.nvim` 全家桶（30+ 模块），未使用纯属常驻开销，已删除。
  {
    'nvim-mini/mini.ai',
    opts = { silent = true },
  },
}