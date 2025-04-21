return {
  name = 'ts_ls',
  cmd = { 'typescript-language-server', '--stdio' },
  root_dir = vim.fs.root(0, { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' }),
  init_options = {
    plugins = {
      {
        name = '@vue/typescript-plugin',
        location = vim.fs.joinpath('/Users/orenherman/Library/pnpm/global/5', 'node_module', '@vue',
          'typescript-plugin'),
        languages = { 'vue' },
      },
    },
  },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
    'vue',
  },
  settings = {
    ts_ls = {},
    volar = {},
  },
  single_file_support = true,
}
