return {
  "coder/claudecode.nvim",
  config = true,
  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<cr>",     desc = "Toggle Claude" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v",            desc = "Send to Claude" },
  },
}
-- return {
--   "greggh/claude-code.nvim",
--   dependencies = {
--     "nvim-lua/plenary.nvim", -- Required for git operations
--   },
--   config = function()
--     require("claude-code").setup()
--   end
-- }
