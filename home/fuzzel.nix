# fuzzel launcher, themed to the rice: sheer near-black panel, mauve border/selection,
# rounded, "❯ " prompt, app icons. Colors from config.rice.theme.colors. niri.nix binds
# Mod+Space / Ctrl+Space / Mod+D to fuzzel and this module installs it.
{ config, ... }:
let
  c = config.rice.theme.colors;
  rgba = alpha: hex: "${builtins.substring 1 6 hex}${alpha}";
in
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Iosevka Nerd Font:size=13";
        prompt = ''"❯ "'';
        icon-theme = "Papirus-Dark";
        icons-enabled = true;
        layer = "overlay";
        width = 40;
        lines = 12;
        horizontal-pad = 22;
        vertical-pad = 16;
        inner-pad = 10;
        line-height = 24;
        image-size-ratio = 0.9;
      };
      border = { width = 2; radius = 12; };
      colors = {
        background = rgba "f2" c.base;
        text = rgba "ff" c.text;
        prompt = rgba "ff" c.mauve;
        input = rgba "ff" c.text;
        placeholder = rgba "ff" c.subtext0;
        match = rgba "ff" c.mauve;
        selection = rgba "ff" c.surface1;
        selection-text = rgba "ff" c.text;
        selection-match = rgba "ff" c.mauve;
        counter = rgba "ff" c.subtext0;
        border = rgba "ff" c.mauve;
      };
    };
  };
}
