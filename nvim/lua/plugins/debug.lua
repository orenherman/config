return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    --    {
    --
    --'mfussenegger/nvim-dap-python',
    --      config = function()
    --      require('dap-python').setup '/Users/orenherman/.virtualenvs/debugpy/bin/python' --"~/venvs/debugpy/bin/python")
    --    require('dap-python').test_runner = 'pytest'
    --      end,
    --  },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {
        function(config)
          require('mason-nvim-dap').default_setup(config)
        end,
        python = function(config)
          config.adapters = {
            type = 'executable',
            command = '/Users/orenherman/.virtualenvs/debugpy/bin/python',
            args = {
              '-m',
              'debugpy.adapter',
            },
          }
          require('mason-nvim-dap').default_setup(config) -- don't forget this!
        end,
      },
      ensure_installed = {
        'delve',
        'python',
      },
    }

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F7>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F8>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F17>', dap.run_to_cursor, { desc = 'Debug: Run to cursor' })
    vim.keymap.set('n', '<F20>', function()
      dapui.eval(nil, { enter = true })
    end, { desc = 'Debug: Eval' })
    vim.keymap.set('n', '<F14>', function()
      dap.close()
      dapui.close()
    end, { desc = 'Debug: Stop' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    vim.keymap.set('n', '<F3>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    dap.adapters.delve = {
      type = 'server',
      port = '${port}',
      executable = {
        command = 'dlv',
        args = { 'dap', '-l', '127.0.0.1:${port}' },
      },
    }

    -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
    dap.configurations.go = {
      {
        type = 'delve',
        name = 'Debug',
        request = 'launch',
        program = '${file}',
      },
      -- works with go.mod packages and sub packages
      {
        type = 'delve',
        name = 'Debug tests (go.mod)',
        request = 'launch',
        mode = 'test',
        program = './${relativeFileDirname}',
      },
      {
        type = 'delve',
        name = 'Debug Single Test',
        request = 'launch',
        mode = 'test',
        program = './${relativeFileDirname}',
        args = function()
          local test_name = vim.fn.expand '<cword>'
          return { '-test.run', test_name }
        end,
      },
      {
        type = 'delve',
        name = 'Debug test', -- configuration for debugging test files
        request = 'launch',
        mode = 'test',
        program = '${file}',
      },
    }
  end,
}
