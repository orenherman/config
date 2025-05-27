return {
  "azorng/goose.nvim",
  config = function()
    require("goose").setup({})
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        anti_conceal = { enabled = false },
        default_global_keymaps = false,
      },
    }
  },
}
