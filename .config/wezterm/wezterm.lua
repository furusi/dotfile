local wezterm = require 'wezterm';
local config = {}

if wezterm.config_builder then
   config = wezterm.config_builder()
end

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

local function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
     return 'Modus-Vivendi'
  else
    return  'Modus-Operandi'
  end
end


config.font = wezterm.font("UDEV Gothic JPDOC")
config.font_size = 16.0
config.color_scheme = scheme_for_appearance(get_appearance())

return config
