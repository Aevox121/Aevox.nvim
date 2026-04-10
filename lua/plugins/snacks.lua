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

              -- Check if a persistence session exists for this project
              local session_dir = vim.fn.stdpath("state") .. "/sessions/"
              local path = item.file:gsub("[/\\]+$", "")
              local encoded = path:gsub("[/\\:]", "%%") .. ".vim"

              if vim.fn.filereadable(session_dir .. encoded) == 1 then
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
