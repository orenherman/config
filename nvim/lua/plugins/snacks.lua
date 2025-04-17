return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
    gitbrowse = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    rename = { enabled = true },
    terminal = { enabled = true, win = { height = 0.2 } },
    scroll = { enabled = true },
    -- statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    {
      '<C-b>w',
      function()
        Snacks.bufdelete()
      end,
      desc = 'Delete Buffer',
    },
    {
      '<leader>gB',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'Git Browse',
      mode = { 'n', 'v' },
    },
    {
      '<c-/>',
      function()
        Snacks.terminal()
      end,
      desc = 'Toggle Terminal',
    },
    {
      '<C-M-/>',
      function()
        Snacks.terminal.open(nil, { win = { height = 0.2 } })
      end,
      desc = 'New Terminal',
    },
  },
  config = function()
    local pickers = require 'telescope.pickers'
    local finders = require 'telescope.finders'
    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'

    local function get_terminal_buffers()
      local bufs = {}
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.b[bufnr].snacks_terminal then
          table.insert(bufs, {
            bufnr = bufnr,
            name = vim.api.nvim_buf_get_name(bufnr),
            snacks_terminal = vim.b[bufnr].snacks_terminal,
          })
        end
      end
      return bufs
    end

    local function terminal_picker()
      local terminals = get_terminal_buffers()

      pickers
        .new({}, {
          prompt_title = 'Terminal Buffers',
          finder = finders.new_table {
            results = terminals,
            entry_maker = function(entry)
              return {
                value = entry.snacks_terminal,
                display = entry.name,
                ordinal = entry.name,
              }
            end,
          },
          attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry().value
              require('snacks.terminal').get(selection.snacks_terminal):show()
            end)

            return true
          end,
        })
        :find()
    end

    vim.keymap.set('n', '<leader>st', function()
      terminal_picker()
    end, { desc = '[S]earch [T]erminals' })
  end,
}
