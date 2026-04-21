local function reveal_in_explorer(_, item)
  if not item or not item.file then return end
  local path = vim.fn.fnamemodify(item.file, ":p")
      :gsub("/", "\\"):gsub("\\+$", "")
  vim.fn.jobstart(
    { "cmd.exe", "/c", "start", "", "explorer", "/select," .. path },
    { detach = true }
  )
end

return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          projects = {
            dev = { "D:/Projects", "D:/Work" },
            max_depth = 4,
            patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "package.json", "Makefile" },
            recent = true,
            confirm = function(picker, item)
              picker:close()
              vim.cmd("tcd " .. vim.fn.fnameescape(item.file))

              -- Use persistence.nvim's own path encoding to find the session file
              local session_file = require("persistence").current()
              if vim.fn.filereadable(session_file) == 1 then
                require("persistence").load()
              else
                Snacks.picker.files()
              end
            end,
          },
          explorer = {
            actions = { reveal_in_explorer = reveal_in_explorer },
            win = {
              list = { keys = { ["gx"] = "reveal_in_explorer" } },
            },
          },
        },
      },
    },
  },
}
