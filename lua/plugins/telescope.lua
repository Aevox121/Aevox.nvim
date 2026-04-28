return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "v0.2.1",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- optional but recommended
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      {
        "<leader>st",
        function() require("util.tasks").picker(false) end,
        desc = "Search active Task files",
      },
      {
        "<leader>sT",
        function() require("util.tasks").picker(true) end,
        desc = "Search all Task files (incl. archive)",
      },
    },
  },
  -- We repurpose <leader>st / <leader>sT for the Task system, so disable
  -- todo-comments' default bindings on those keys.
  {
    "folke/todo-comments.nvim",
    keys = {
      { "<leader>st", false },
      { "<leader>sT", false },
    },
  },
}
