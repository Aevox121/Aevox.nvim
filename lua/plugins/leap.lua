return {
  "ggandor/leap.nvim",
  config = function()
    -- 这里是 leap.nvim 的基础配置，你可以后续按需调整
    require('leap').add_default_mappings()
  end,
}