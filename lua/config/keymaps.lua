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

-- Tab navigation (normal + terminal mode). Works in any buffer, including
-- fourclaude's embedded-zellij :terminal. `<M-,>` / `<M-.>` chosen instead of
-- `<M-[>` / `<M-]>` because `Alt+[` sends `ESC [` which is the CSI prefix for
-- arrow keys and F-keys — binding it makes nvim wait ttimeoutlen on every
-- arrow press. And instead of `<M-h>` / `<M-l>` because those collide with
-- zellij's default pane-switch inside fourclaude.
-- Requires Ghostty `macos-option-as-alt = true` on mac.
vim.keymap.set({ "n", "t" }, "<M-,>", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
vim.keymap.set({ "n", "t" }, "<M-.>", "<cmd>tabnext<cr>", { desc = "Next tab" })

-- <leader>ch in markdown: toggle `- [ ]` <-> `- [x]` on the current line.
-- Buffer-local so it doesn't shadow the global <leader>c (code) group elsewhere.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(ev)
    vim.keymap.set("n", "<leader>ch", function()
      local line = vim.api.nvim_get_current_line()
      local new = line
      if line:match("^%s*[%-%*%+]%s*%[ %]") then
        new = line:gsub("(%[)( )(%])", "%1x%3", 1)
      elseif line:match("^%s*[%-%*%+]%s*%[[xX]%]") then
        new = line:gsub("(%[)[xX](%])", "%1 %2", 1)
      end
      if new ~= line then vim.api.nvim_set_current_line(new) end
    end, { buffer = ev.buf, desc = "Toggle markdown checkbox" })
  end,
})

-- dm{a-zA-Z} to delete a mark. Press dm, then a single char to pick which.
-- <Esc> aborts.
vim.keymap.set("n", "dm", function()
  local ok, c = pcall(vim.fn.getcharstr)
  if not ok or c == "" or c == "\27" then return end -- <Esc>
  if not c:match("^[%a]$") then
    vim.notify("dm: expected a-z or A-Z, got " .. vim.inspect(c), vim.log.levels.WARN)
    return
  end
  vim.cmd("delmarks " .. c)
  vim.notify("deleted mark " .. c)
end, { desc = "Delete mark (dm{a-zA-Z})" })
