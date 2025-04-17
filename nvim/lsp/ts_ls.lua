local function global_node_modules()
  local global_path = ''
  if vim.fn.isdirectory '/opt/homebrew/lib/node_modules' == 1 then
    global_path = '/opt/homebrew/lib/node_modules'
  elseif vim.fn.isdirectory '/usr/local/lib/node_modules' == 1 then
    global_path = '/usr/local/lib/node_modules'
  elseif vim.fn.isdirectory '/usr/lib64/node_modules' == 1 then
    global_path = '/usr/lib64/node_modules'
  else
    global_path = vim.fs.joinpath(os.getenv 'HOME', '.npm', 'lib', 'node_modules')
  end
  if vim.fn.isdirectory(global_path) == 0 then
    vim.notify('Global node_modules not found', vim.log.levels.DEBUG)
  end
  return global_path
end

return {
  name = 'ts_ls',
  cmd = { 'typescript-language-server', '--stdio' },
  root_dir = vim.fs.root(0, { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' }),
  -- init_options = {
  --   plugins = {
  --     {
  --       name = '@vue/typescript-plugin',
  --       location = vim.fs.joinpath(global_node_modules(), '@vue', 'typescript-plugin'),
  --       languages = { 'vue' },
  --     },
  --   },
  -- },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
    -- 'vue',
  },
  settings = {
    ts_ls = {},
  },
  single_file_support = true,
}
