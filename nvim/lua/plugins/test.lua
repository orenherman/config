return {
  {
    'nvim-neotest/neotest',
    ft = { 'python', 'go' },
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      {
        'fredrikaverpil/neotest-golang', -- Installation
        dependencies = {
          'leoluz/nvim-dap-go',
        },
      },
      'nvim-neotest/neotest-python',
      'marilari88/neotest-vitest',
    },
    config = function()
      local neotest = require 'neotest'
      neotest.setup {
        adapters = {
          require 'neotest-golang',
          require 'neotest-vitest',
          require 'neotest-python' {
            runner = 'pytest',
            python = '/Users/orenherman/.virtualenvs/debugpy/bin/python',
            dap = { python = { '-Xfrozen_modules=off', '--multiprocess', '--qt-support=auto' } },
          },
        },
        log_level = 1,
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
      vim.keymap.set('n', '<leader>td', function()
        neotest.run.run { suite = false, strategy = 'dap' }
      end, { desc = '[T]est [D]ebug' })
    end,
  },
}
