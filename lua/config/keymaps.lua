-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- leap
-- 映射 s 键进入 Leap 的前向搜索模式
vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap-forward)', { desc = 'Leap forward' })
vim.keymap.set({'n', 'x', 'o'}, 'S', '<Plug>(leap-backward)', { desc = 'Leap backward' })

