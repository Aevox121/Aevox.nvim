return {
  {
    "Aevox121/ch-ime.nvim",
    main = "ch-ime",
    -- Lazy-load on commands/keys
    cmd = {
      "ChImeToggle",
      "ChImeEnable",
      "ChImeDisable",
      "ChImeInstall",
      "ChImeDetect",
      "ChImeStatus",
    },
    opts = {
      enabled = true,
      im_select = "auto",
      install = { on_startup = true },
      normal_im = {
        windows = "1033",
        macos = "com.apple.keylayout.ABC",
      },
      insert_im = {
        windows = "2052",
        macos = "com.sogou.inputmethod.sogou.pinyin",
      },
      -- 默认会排除 TelescopePrompt 和 prompt/nofile buftype，picker 输入框就被
      -- 挡掉了。这里都清空，<leader>ff / <leader>sb / <leader>fg 打开 picker
      -- 时进 insert 模式即切中文，方便搜中文内容。
      exclude_filetypes = {},
      exclude_buftype = {},
    },
    keys = {
      {
        "<leader>ui",
        function()
          require("ch-ime").toggle()
        end,
        desc = "Toggle ChIme",
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      opts.sections = opts.sections or {}
      opts.sections.lualine_x = opts.sections.lualine_x or {}
      table.insert(opts.sections.lualine_x, 1, function()
        local ok, m = pcall(require, "ch-ime")
        return ok and m.statusline() or "IME-"
      end)
    end,
  },
}
