return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      'nvim-telescope/telescope-live-grep-args.nvim',
    },
    config = function()
      local lga_actions = require 'telescope-live-grep-args.actions'
      local actions = require 'telescope.actions'
      require('telescope').setup {
        defaults = {
          file_ignore_patterns = {
            '%.pb%.go$',
            '%.pb%.validate%.go$',
            '%.connect%.go$',
          },
          mappings = {
            n = {
              ['<C-w>'] = actions.delete_buffer,
            },
            i = {
              ['<C-w>'] = actions.delete_buffer,
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          live_grep_args = {
            auto_quoting = true,
            mappings = { -- extend mappings
              i = {
                ['<C-k>'] = lga_actions.quote_prompt(),
                ['<C-i>'] = lga_actions.quote_prompt { postfix = ' --iglob ' },
                ['<C-space>'] = actions.to_fuzzy_refine,
              },
            },
          },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'live_grep_args')

      local builtin = require 'telescope.builtin'
      local utils = require 'telescope.utils'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch [B]uffers' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sg', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>se', builtin.lsp_document_symbols, { desc = '[S]earch Document Symbols' })
      vim.keymap.set('n', '<leader>sq', builtin.quickfix, { desc = '[S]earch [Q]uickfix' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })

      vim.keymap.set('n', '<leader>sw', function()
        builtin.grep_string { search_dirs = { '%:p' } }
      end, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sf', function()
        builtin.find_files { find_command = { 'rg', '--files', '--hidden', '-g', '!.git' } }
      end, { desc = '[S]earch [F]iles' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
  {
    'danielfalk/smart-open.nvim',
    branch = '0.2.x',
    config = function()
      require('telescope').load_extension 'smart_open'
      vim.keymap.set('n', '<leader><leader>', function()
        require('telescope').extensions.smart_open.smart_open()
      end, { noremap = true, silent = true, desc = '[ ] Find existing buffers' })
    end,
    dependencies = {
      'kkharji/sqlite.lua',
      -- Only required if using match_algorithm fzf
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
      { 'nvim-telescope/telescope-fzy-native.nvim' },
    },
  },
}
