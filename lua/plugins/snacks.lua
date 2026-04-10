-- [MANUAL] Configure the `dev` paths below to match your local project directories.
-- Example:
--   Windows: dev = { "D:/Projects", "D:/Work" },
--   macOS:   dev = { "~/Projects", "~/Work" },

return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          projects = {
            dev = {},
            max_depth = 4,
            patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "package.json", "Makefile" },
            recent = true,
            confirm = function(picker, item)
              picker:close()
              vim.cmd("tcd " .. vim.fn.fnameescape(item.file))

              -- If a persistence session exists, restore it; otherwise open file picker
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
