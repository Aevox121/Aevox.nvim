-- Extend LazyVim's default lualine with a Four Claude live indicator.
-- Shows "● Claude" (or "● Claude×N" with N instances) in lualine_x
-- whenever fourclaude has at least one live tab.

local function fc_status()
  local ok, fc = pcall(require, "four-claude")
  if not ok then return "" end
  return fc.status()
end

return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    opts.sections = opts.sections or {}
    opts.sections.lualine_x = opts.sections.lualine_x or {}
    table.insert(opts.sections.lualine_x, 1, {
      fc_status,
      cond = function() return fc_status() ~= "" end,
      color = { fg = "#ff9e64" },
    })
  end,
}
