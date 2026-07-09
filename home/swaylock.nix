# swaylock (swaylock-effects) lock screen, themed to the rice: mauve ring on input,
# red on wrong password, muted surface tones. The blurred background comes from
# niri.nix's lockScript (grim -> imagemagick -> swaylock -i); this owns the ring/text.
# Colors from config.rice.theme.colors.
{ config, pkgs, ... }:
let
  c = config.rice.theme.colors;
  rgba = alpha: hex: "${builtins.substring 1 6 hex}${alpha}";
  opaque = rgba "ff";
in
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      color = builtins.substring 1 6 c.base;

      clock = true;
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;

      hide-keyboard-layout = true;
      show-failed-attempts = true;

      ring-color = opaque c.mauve;
      ring-clear-color = opaque c.surface2;
      ring-ver-color = opaque c.blue;
      ring-wrong-color = opaque c.red;

      inside-color = rgba "cc" c.base;
      inside-clear-color = rgba "cc" c.surface1;
      inside-ver-color = rgba "cc" c.surface1;
      inside-wrong-color = rgba "cc" c.base;

      key-hl-color = opaque c.mauve;
      bs-hl-color = opaque c.red;

      line-color = opaque c.surface1;
      line-clear-color = opaque c.surface1;
      line-ver-color = opaque c.surface1;
      line-wrong-color = opaque c.surface1;
      separator-color = "00000000";

      text-color = opaque c.text;
      text-clear-color = opaque c.subtext0;
      text-ver-color = opaque c.text;
      text-wrong-color = opaque c.red;
    };
  };
}
