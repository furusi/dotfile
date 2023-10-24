local wezterm = require 'wezterm';
local config = {}

if wezterm.config_builder then
   config = wezterm.config_builder()
end

config.font = wezterm.font("UDEV Gothic JPDOC")
config.font_size = 16.0
config.color_scheme = 'Modus-Operandi'

return config
