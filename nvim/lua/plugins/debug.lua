return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'leoluz/nvim-dap-go',
      'mxsdev/nvim-dap-vscode-js',
      {
        'microsoft/vscode-js-debug',
        version = '1.x',
        build = 'npm i && npm run compile vsDebugServerBundle && mv dist out',
      },
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
            local home_dir = os.getenv 'HOME'
            config.adapters = {
              type = 'executable',
              command = home_dir .. '/.virtualenvs/debugpy/bin/python',
              args = {
                '-m',
                'debugpy.adapter',
              },
            }
            require('mason-nvim-dap').default_setup(config)
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
        layouts = {
          {
            elements = {
              {
                id = 'scopes',
                size = 0.75,
              },
              {
                id = 'breakpoints',
                size = 0.25,
              },
            },
            position = 'left',
            size = 70,
          },
          {
            elements = {
              {
                id = 'console',
                size = 1,
              },
            },
            position = 'bottom',
            size = 25,
          },
        },
      }

      vim.keymap.set('n', '<F3>', dapui.toggle, { desc = 'Debug: See last session result.' })

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      -- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      require('dap-vscode-js').setup {
        debugger_path = vim.fn.stdpath 'data' .. '/lazy/vscode-js-debug',
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
      }
      for _, language in ipairs { 'typescript', 'javascript' } do
        dap.configurations[language] = {
          {
            type = 'pwa-node',
            request = 'attach',
            processId = require('dap.utils').pick_process,
            name = 'Attach debugger to existing `node --inspect` process',
            sourceMaps = true,
            resolveSourceMapLocations = {
              '${workspaceFolder}/**',
              '!**/node_modules/**',
            },
            cwd = '${workspaceFolder}/src',
            skipFiles = { '${workspaceFolder}/node_modules/**/*.js' },
          },
          {
            type = 'pwa-chrome',
            name = 'Launch Chrome to debug client',
            request = 'launch',
            url = 'http://localhost:5173',
            sourceMaps = true,
            protocol = 'inspector',
            port = 9222,
            webRoot = '${workspaceFolder}/src',
            skipFiles = { '**/node_modules/**/*', '**/@vite/*', '**/src/client/*', '**/src/*' },
          },
          language == 'javascript' and {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch file in new node process',
            program = '${file}',
            cwd = '${workspaceFolder}',
          } or nil,
        }
      end

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
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    config = function()
      require('nvim-dap-virtual-text').setup()
    end,
  },
}
