-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("x", "<leader>ff", function()
  local text = table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos(".")))
  builtin.find_files({ default_text = text })
end, { desc = "Find files by selection" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- Reveal current file in Windows Explorer
vim.keymap.set("n", "gX", function()
  local path = vim.fn.expand("%:p")
  if path == "" then
    vim.fn.jobstart({ "explorer.exe", vim.fn.getcwd() }, { detach = true })
  else
    vim.fn.jobstart({ "explorer.exe", "/select,", path }, { detach = true })
  end
end, { desc = "Reveal in Explorer" })


