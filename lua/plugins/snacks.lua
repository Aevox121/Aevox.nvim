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
        },
      },
    },
  },
}
