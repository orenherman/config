local M = {}

-- Setup function to initialize the module
function M.setup(opts)
  opts = opts or {}

  local dap = require('dap')
  local dapui = require('dapui')
  function M.attach_to_mirrord_delve(port)
    local port = port or 2345 -- Default Delve port if not specified

    dap.configurations.delve = {
      {
        type = "go",
        name = "Attach to mirrord Delve",
        request = "attach",
        mode = "remote",
        remotePath = "", -- Leave empty to use the same paths as local
        port = port,
        host = "127.0.0.1",
        stopOnEntry = false,
        showLog = true,
        trace = true, -- Enable for more verbose logs
      }
    }

    dap.continue() -- Start debugging session
    dapui.open()   -- Open debugging UI
  end

  vim.api.nvim_create_user_command('AttachMirrordDelve', function(opts)
    local port = tonumber(opts.args) or 2345
    M.attach_to_mirrord_delve(port)
  end, { nargs = '?', desc = 'Attach to mirrord Delve process (optional port)' })
  --
  -- Helper function to run mirrord with Delve
  function M.mirrord_with_delve(target, port)
    local port = port or 2345
    local cmd = string.format('mirrord exec --target %s -- dlv debug --headless --listen=127.0.0.1:%d --api-version=2',
      target, port)

    -- Create a new terminal buffer
    vim.cmd('new')
    local buf = vim.api.nvim_get_current_buf()
    vim.fn.termopen(cmd, {
      on_exit = function(job_id, exit_code, event_type)
        print("mirrord-delve process exited with code: " .. exit_code)
      end
    })

    -- Return to the previous window
    vim.cmd('wincmd p')

    -- Show message to user
    print(string.format("Started mirrord with Delve on port %d. Use :AttachMirrordDelve %d to connect", port, port))
  end

  -- Command to run mirrord with Delve
  vim.api.nvim_create_user_command('MirrordDelve', function(opts)
    local args = vim.split(opts.args, ' ')
    local target = args[1] or ""
    local port = tonumber(args[2]) or 2345

    if target == "" then
      print("Error: Target is required (e.g., :MirrordDelve deployment/my-app 2345)")
      return
    end

    M.mirrord_with_delve(target, port)
  end, { nargs = '+', desc = 'Run mirrord with Delve (target [port])' })
end

return M
