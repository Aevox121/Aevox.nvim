-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- telescope
local builtin = require("telescope.builtin")
local reveal = require("util.reveal").reveal

-- In a telescope picker, press `gx` (normal mode) to reveal the highlighted
-- entry in Windows Explorer.
local function reveal_attach()
  return {
    attach_mappings = function(_, map)
      map("n", "gx", function(prompt_bufnr)
        local entry = require("telescope.actions.state").get_selected_entry()
        if not entry then return end
        local path = entry.path or entry.filename
            or (type(entry.value) == "string" and entry.value) or nil
        if not path then return end
        require("telescope.actions").close(prompt_bufnr)
        reveal(path)
      end)
      return true
    end,
  }
end

vim.keymap.set("n", "<leader>ff", function()
  builtin.find_files(reveal_attach())
end, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("x", "<leader>ff", function()
  local text = table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos(".")))
  local opts = reveal_attach()
  opts.default_text = text
  builtin.find_files(opts)
end, { desc = "Find files by selection" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
