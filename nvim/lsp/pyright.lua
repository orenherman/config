local function get_python_path(workspace)
  -- First, try to find a virtual environment in common locations
  local venv_paths = {
    workspace .. '/.venv/bin/python',
    workspace .. '/venv/bin/python',
    workspace .. '/env/bin/python',
    workspace .. '/.env/bin/python',
  }

  for _, path in ipairs(venv_paths) do
    if vim.fn.executable(path) == 1 then
      vim.notify("Using virtualenv python: " .. path)
      return path
    end
  end

  -- Fallback to system python
  return "/Users/orenherman/.virtualenvs/debugpy/bin/python"
end

return {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python', 'py' },
  root_markers = {
    'Pipfile',
    'setup.py',
    'setup.cfg',
    'pyproject.toml',
    'requirements.txt',
    'pyrightconfig.json',
  },
  single_file_support = true,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
  },
  on_attach = function(client, _)
    local root_dir = nil

    if client.workspace_folders and #client.workspace_folders > 0 then
      root_dir = client.workspace_folders[1].name
    end

    if root_dir then
      local ppath = get_python_path(root_dir)
      client.config.settings.python.pythonPath = ppath

      client.notify('workspace/didChangeConfiguration', {
        settings = client.config.settings
      })
    end
  end,
}
