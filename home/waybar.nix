# waybar for the niri desktop. A flat near-black hairline strip pinned to the top,
# FIELD:value console readouts. Ported from vmfunc/nixfiles; the FFXIV clock was
# dropped and a battery module added (shows on the laptop, hides on the desktop).
# Colors come from config.rice.theme.colors (theme.nix). Started by its own systemd
# user unit on graphical-session.target, not by niri spawn-at-startup.
{ config, pkgs, ... }:
let
  c = config.rice.theme.colors;
  field = label: "<span color='${c.subtext0}'>${label}</span>";
  value = color: v: "<span color='${color}'>${v}</span>";
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 26;
      spacing = 0;

      modules-left = [ "niri/workspaces" "custom/sep" "niri/window" ];
      modules-center = [ "clock" ];
      modules-right = [ "cpu" "memory" "network" "battery" "pulseaudio" "tray" ];

      "niri/workspaces".format = "{index}";

      "custom/sep" = { format = "::"; tooltip = false; };

      "niri/window" = {
        max-length = 48;
        format = "${field "APP:"} ${value c.mauve "{title}"}";
      };

      clock = {
        format = "${field "TIME:"} ${value c.text "{:%a %d %b %H:%M}"}";
        format-alt = "${field "TIME:"} ${value c.text "{:%H:%M:%S}"}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
      };

      cpu = {
        format = "${field "CPU:"} ${value c.mauve "{usage}%"}";
        interval = 3;
      };

      memory = {
        format = "${field "MEM:"} ${value c.green "{percentage}%"}";
        interval = 5;
      };

      network = {
        format-wifi = "${field "NET:"} ${value c.mauve "{bandwidthDownBytes}"}";
        format-ethernet = "${field "NET:"} ${value c.mauve "{bandwidthDownBytes}"}";
        format-disconnected = "${field "NET:"} ${value c.subtext0 "DOWN"}";
        interval = 3;
        tooltip-format = "{ifname}: {ipaddr}";
      };

      battery = {
        # hidden automatically when no battery device is present (desktop).
        states = { warning = 30; critical = 15; };
        format = "${field "BAT:"} ${value c.green "{capacity}%"}";
        format-warning = "${field "BAT:"} ${value c.yellow "{capacity}%"}";
        format-critical = "${field "BAT:"} ${value c.red "{capacity}%"}";
        format-charging = "${field "BAT:"} ${value c.mauve "{capacity}%"}";
        interval = 10;
        tooltip-format = "{timeTo}";
      };

      pulseaudio = {
        format = "${field "VOL:"} ${value c.mauve "{volume}%"}";
        format-muted = "${field "VOL:"} ${value c.subtext0 "MUTE"}";
        on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
      };

      tray.spacing = 8;
    };

    style = ''
      * {
        font-family: "Iosevka Nerd Font", "Symbols Nerd Font";
        font-size: 12px;
        font-weight: 700;
        min-height: 0;
      }

      window#waybar {
        background: alpha(${c.crust}, 0.94);
        color: ${c.text};
        border-bottom: 1px solid ${c.surface1};
      }

      #workspaces, #window, #clock, #cpu, #memory, #network,
      #battery, #pulseaudio, #custom-sep, #tray {
        background: transparent;
        border-radius: 0;
        padding: 0 8px;
        margin: 0;
      }

      #workspaces button {
        color: ${c.subtext0};
        background: transparent;
        border-radius: 0;
        padding: 0 5px;
        margin: 0;
      }
      #workspaces button.active,
      #workspaces button.focused { color: ${c.mauve}; }
      #workspaces button.urgent { color: ${c.red}; }

      #custom-sep { color: ${c.surface2}; padding: 0 4px; }
      #tray { padding: 0 6px; }
    '';
  };
}
