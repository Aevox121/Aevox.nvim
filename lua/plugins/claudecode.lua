return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = function()
    local env = {}

    local function first_non_empty(...)
      for i = 1, select("#", ...) do
        local value = select(i, ...)
        if type(value) == "string" and value ~= "" then
          return value
        end
      end
    end

    local http_proxy = first_non_empty(vim.g.claudecode_proxy_http, vim.env.HTTP_PROXY, vim.env.http_proxy)
    local https_proxy = first_non_empty(vim.g.claudecode_proxy_https, vim.env.HTTPS_PROXY, vim.env.https_proxy, http_proxy)
    local all_proxy = first_non_empty(vim.g.claudecode_all_proxy, vim.env.ALL_PROXY, vim.env.all_proxy)
    local no_proxy = first_non_empty(vim.g.claudecode_no_proxy, vim.env.NO_PROXY, vim.env.no_proxy)

    if http_proxy then
      env.HTTP_PROXY = http_proxy
      env.http_proxy = http_proxy
    end

    if https_proxy then
      env.HTTPS_PROXY = https_proxy
      env.https_proxy = https_proxy
    end

    if all_proxy then
      env.ALL_PROXY = all_proxy
      env.all_proxy = all_proxy
    end

    if no_proxy then
      env.NO_PROXY = no_proxy
      env.no_proxy = no_proxy
    end

    return {
      env = env,
    }
  end,
  config = true,
  keys = {
    { "<leader>a", nil, desc = "AI/Claude Code" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
    },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
}
