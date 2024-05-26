return {
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
  {
    'folke/tokyonight.nvim',
    priority = 1000,
  },
  { 'ellisonleao/gruvbox.nvim', priority = 999, config = true },
  {
    'rebelot/kanagawa.nvim',
    priority = 1001,
    init = function()
      vim.cmd.colorscheme 'kanagawa-wave'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
