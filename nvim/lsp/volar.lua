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

local function get_typescript_server_path(root_dir)
  local found_ts = vim.fs.joinpath(root_dir, 'node_modules', 'typescript', 'lib')
  if vim.fn.isdirectory(found_ts) == 1 then
    return found_ts
  end
  return vim.fs.joinpath(global_node_modules(), 'typescript', 'lib')
end

return {
  name = 'volar',
  cmd = { 'vls', '--stdio' },
  root_dir = vim.fs.root(0, { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' }),
  init_options = {
    vue = {
      hybridMode = true
    }
  },
  settings = {
    typescript = {
      inlayHints = {
        enumMemberValues = {
          enabled = true,
        },
        functionLikeReturnTypes = {
          enabled = true,
        },
        propertyDeclarationTypes = {
          enabled = true,
        },
        parameterTypes = {
          enabled = true,
          suppressWhenArgumentMatchesName = true,
        },
        variableTypes = {
          enabled = true,
        },
      },
    },
  },
}
