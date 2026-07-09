# swayosd on-screen display: volume/brightness keypresses pop a themed bar. The server
# runs as a systemd user service; niri.nix binds the media keys to swayosd-client.
# Colors from config.rice.theme.colors.
{ config, pkgs, ... }:
let
  c = config.rice.theme.colors;
in
{
  home.packages = [ pkgs.swayosd ];

  systemd.user.services.swayosd = {
    Unit = {
      Description = "swayosd on-screen display server";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.swayosd}/bin/swayosd-server";
      Restart = "always";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  xdg.configFile."swayosd/style.css".text = ''
    window#osd {
      border-radius: 0;
      border: 1px solid ${c.surface1};
      background: alpha(${c.base}, 0.94);
      padding: 4px;
    }
    window#osd #container { margin: 16px; }
    window#osd image, window#osd label { color: ${c.text}; }
    window#osd progressbar:disabled, window#osd image:disabled { opacity: 0.5; }
    window#osd progressbar {
      min-height: 6px; border-radius: 0; background: transparent; border: none;
    }
    window#osd trough {
      min-height: 6px; border-radius: 0; border: none; background: ${c.surface2};
    }
    window#osd progress {
      min-height: 6px; border-radius: 0; border: none; background: ${c.mauve};
    }
  '';
}
