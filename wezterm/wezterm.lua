-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Color scheme - OneDark
config.color_scheme = 'OneDark (base16)'

-- Font configuration
config.font = wezterm.font_with_fallback({
  'JetBrains Mono',
  'Fira Code',
  'Cascadia Code',
  'Consolas',
})
config.font_size = 11.0

-- Window appearance
config.window_background_opacity = 0.95
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}

-- Tab bar
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false

-- Tab bar colors (OneDark theme)
config.colors = {
  tab_bar = {
    background = '#282c34',
    active_tab = {
      bg_color = '#61afef',
      fg_color = '#282c34',
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = '#3e4451',
      fg_color = '#abb2bf',
    },
    inactive_tab_hover = {
      bg_color = '#4b5263',
      fg_color = '#abb2bf',
    },
    new_tab = {
      bg_color = '#282c34',
      fg_color = '#abb2bf',
    },
    new_tab_hover = {
      bg_color = '#3e4451',
      fg_color = '#abb2bf',
    },
  },
}

-- Scrollback
config.scrollback_lines = 10000

-- Default program (PowerShell on Windows)
config.default_prog = { 'pwsh.exe' }

-- Keybindings
config.keys = {
  -- Split panes
  {
    key = '-',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = '|',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  -- Navigate panes
  {
    key = 'h',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'l',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  {
    key = 'k',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'j',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },
  -- Close pane
  {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  -- Copy/Paste
  {
    key = 'c',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CopyTo 'Clipboard',
  },
  {
    key = 'v',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
}

-- Mouse bindings
config.mouse_bindings = {
  -- Change the default click behavior so that it only selects text and doesn't open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection',
  },
  -- Ctrl-click will open the link under the mouse cursor
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

-- Cursor style
config.default_cursor_style = 'SteadyBar'

-- Return the configuration to wezterm
return config

