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
      -- Neovide 失/获焦各触发一次 IM 切换；alt-tab 或系统弹窗都会连发。关掉
      -- 后只在真正进入/离开 insert/terminal 时切。
      restore_on_focus_lost = false,
      -- 默认 50ms 太短挡不住 fourclaude WinEnter→startinsert 引发的连发
      -- (TermEnter + InsertEnter + ModeChanged 同时触发)。
      debounce_ms = 250,
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
