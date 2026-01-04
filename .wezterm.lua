local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- config.font = wezterm.font("FiraCode Nerd Font Mono")
-- config.font = wezterm.font("Monaspace Argon")
-- config.font = wezterm.font("Monaspace Neon Var")
config.font_size = 13

config.color_scheme = 'Kanagawa (Gogh)'
-- config.color_scheme = "Tokyo Night"

config.window_decorations = 'RESIZE'

config.window_background_opacity = 0.97
config.macos_window_background_blur = 50
config.initial_rows = 24
config.keys = {
  { key = 'RightArrow', mods = 'ALT',   action = wezterm.action { SendKey = { key = 'f', mods = 'ALT' } } },
  { key = "Enter",      mods = "SHIFT", action = wezterm.action { SendString = "\x1b\r" } },
  { key = 'LeftArrow',  mods = 'ALT',   action = wezterm.action { SendKey = { key = 'b', mods = 'ALT' } } },
  { key = 'k',          mods = 'CMD',   action = wezterm.action.ClearScrollback 'ScrollbackAndViewport' },
  { key = 'K',          mods = 'CMD',   action = wezterm.action.ClearScrollback 'ScrollbackOnly' },
  {
    key = 'W',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  {
    key = 'd',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitPane {
      direction = 'Down',
      size = { Percent = 15 },
    },
  },
  {
    key = 'Tab',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = 'Tab',
    mods = 'CTRL',
    action = wezterm.action.ActivateTabRelative(1),
  },
}


-- Format tab titles with icons and colors
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local process_name = tab.active_pane.foreground_process_name
  if process_name then
    process_name = process_name:match("([^/]+)$") -- Get basename
  end
  local display_title = process_name or 'zsh'

  -- Choose icon based on content
  local icon = ''
  if process_name:match('nvim') then
    icon = ' '
    local pane = tab.active_pane
    local uri = pane.current_working_dir
    cwd = uri.file_path or uri
    cwd = cwd:match("([^/]+)/?$") or cwd
    display_title = ' nvim - ' .. (cwd)
  elseif process_name:match('k9s') then
    icon = '☸ '
  elseif process_name:match('zsh') or process_name:match('bash') then
    icon = ' '
  end

  return {
    { Text = ' ' .. icon .. display_title .. ' ' },
  }
end)

return config
