# mako notifications, themed to the rice: sheer near-black panel, hairline mauve
# outline, square corners, accent title over soft body. Colors from
# config.rice.theme.colors. niri.nix spawns the daemon at startup.
{ config, pkgs, ... }:
let
  c = config.rice.theme.colors;
in
{
  services.mako = {
    enable = true;
    settings = {
      anchor = "top-right";
      layer = "top";
      margin = "12";
      width = 380;
      height = 160;
      padding = "10,14";
      max-visible = 5;

      font = "Iosevka Nerd Font 10";
      background-color = "${c.base}f2";
      text-color = c.text;
      border-size = 2;
      border-color = c.mauve;
      border-radius = 0;
      format = ''<b><span color='${c.mauve}'>%s</span></b>\n%b'';
      progress-color = "over ${c.surface1}";

      icons = true;
      max-icon-size = 48;
      icon-path = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";

      default-timeout = 6000;

      "urgency=low" = {
        border-color = c.surface2;
        format = ''<b><span color='${c.subtext0}'>%s</span></b>\n%b'';
      };
      "urgency=critical" = {
        border-color = c.red;
        format = ''<b><span color='${c.red}'>%s</span></b>\n%b'';
        default-timeout = 0;
      };
    };
  };
}
