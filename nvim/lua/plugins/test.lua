return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-go',
      'marilari88/neotest-vitest',
    },
    config = function()
      local neotest = require 'neotest'
      neotest.setup {
        adapters = {
          require 'neotest-go',
          require 'neotest-vitest',
        },
      }

      vim.keymap.set('n', '<leader>tt', function()
        neotest.summary.toggle()
      end, { desc = '[T]est [T]oggle' })
      vim.keymap.set('n', '<leader>ts', function()
        neotest.output.open()
      end, { desc = '[T]est [S]how' })
      vim.keymap.set('n', '<leader>tr', function()
        neotest.run.run()
      end, { desc = '[T]est [R]un' })
    end,
  },
}
