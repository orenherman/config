return {
  'nvim-neotest/neotest',
  ft = { 'python', 'go', 'typescript', 'javascript' },
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
    'nvim-neotest/neotest-jest',
  },
  cmd = {
    'Neotest',
  },
  config = function()
    local neotest = require 'neotest'
    local home_dir = os.getenv 'HOME'
    neotest.setup {
      adapters = {
        require 'neotest-golang' {
          dap_go_enabled = true,
        },
        require 'neotest-vitest',
        require 'neotest-python' {
          runner = 'pytest',
          python = home_dir .. '/.virtualenvs/debugpy/bin/python',
          dap = {
            python = { '-Xfrozen_modules=off', '--multiprocess', '--qt-support=auto' },
            console = 'integratedTerminal',
            justMyCode = false,
            subProcess = true,
          },
        },
        require 'neotest-jest' {
          -- jestCommand = 'npm test --',
          jestCommand = function(path)
            print('path', path)
            if string.find(path, 'ui/tests/integration', 1, true) then
              return 'npm run test:integration --'
            end
            if string.find(path, 'ui/tests/unit', 1, true) then
              return 'npm run test:unit --'
            end
            return 'npm test --'
          end,
          jestConfigFile = 'custom.jest.config.ts',
          env = { CI = true },
          cwd = function(path)
            return vim.fn.getcwd()
          end,
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
}
