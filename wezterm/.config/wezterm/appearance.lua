local wezterm = require("wezterm")

-- Define your existing module
local module = {}

-- Returns a bool based on whether the host operating system's
-- appearance is light or dark.
function module.is_dark()
  -- wezterm.gui is not always available, depending on what
  -- environment wezterm is operating in. Just return true
  -- if it's not defined.
  if wezterm.gui then
    -- Some systems report appearance like "Dark High Contrast"
    -- so let's just look for the string "Dark" and if we find
    -- it assume appearance is dark.
    return wezterm.gui.get_appearance():find("Dark")
  end
  return true
end

-- Main configuration function
function module.setup()
  local config = {}

  -- Set Tokyo Night Storm as the color scheme
  config.color_scheme = "Tokyo Night Storm"

  -- Add the Tokyo Night Storm theme if it's not already included
  config.color_schemes = {
    ["Tokyo Night Storm"] = {
      foreground = "#a9b1d6",
      background = "#24283b",
      cursor_bg = "#c0caf5",
      cursor_fg = "#24283b",
      cursor_border = "#c0caf5",
      selection_bg = "#364a82",
      selection_fg = "#c0caf5",
      ansi = { "#1d202f", "#f7768e", "#9ece6a", "#e0af68", "#7aa2f7", "#bb9af7", "#7dcfff", "#a9b1d6" },
      brights = { "#414868", "#f7768e", "#9ece6a", "#e0af68", "#7aa2f7", "#bb9af7", "#7dcfff", "#c0caf5" },
    },
  }

  return config
end

return module
