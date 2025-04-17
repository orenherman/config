-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  event = 'VimEnter',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\\\', ':Neotree toggle<CR>', { desc = 'NeoTree toggle' } },
    { '\\r', ':Neotree reveal<CR>', { desc = 'NeotTree reveal' } },
  },
  init = function()
    if vim.fn.argc(-1) == 1 then
      local stat = vim.loop.fs_stat(vim.fn.argv(0))
      if stat and stat.type == 'directory' then
        require('neo-tree').setup {
          filesystem = {
            hijack_netrw_behavior = 'open_current',
            follow_current_file = {
              enabled = true,
            },
          },
        }
      end
    end
  end,
  opts = {
    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      window = {
        mappings = {
          ['\\\\'] = 'close_window',
        },
      },
    },
  },
}
