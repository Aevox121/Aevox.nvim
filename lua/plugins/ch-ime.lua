return {
  {
    "Aevox121/ch-ime.nvim",
    main = "ch-ime",
    cmd = {
      "ChImeToggle",
      "ChImeEnable",
      "ChImeDisable",
      "ChImeInstall",
      "ChImeDetect",
      "ChImeStatus",
    },
    opts = {
      enabled = false,
      im_select = "auto",
      install = { on_startup = true },
      -- [MANUAL] Set your IM identifiers:
      --   Windows: normal_im = "1033", insert_im = "2052"
      --   macOS:   normal_im = "com.apple.keylayout.ABC", insert_im = "com.apple.inputmethod.SCIM.ITABC"
      normal_im = "",
      insert_im = "",
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
