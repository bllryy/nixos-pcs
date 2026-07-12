# niri (scrollable-tiling wayland compositor) user config. Ported from vmfunc/nixfiles,
# de-machine-specified: solid wallpaper via swaybg (no custom swww fork), kitty as the
# terminal, no hardcoded monitor, no clipboard-history daemon. Colors come from
# config.rice.theme.colors (theme.nix); waybar/fuzzel/mako/swaylock/swayosd own their
# own styling. niri's typed KDL settings come from the niri-flake home module.
{ config, lib, pkgs, ... }:
let
  c = config.rice.theme.colors;
  inherit (config.lib.niri.actions)
    spawn close-window
    focus-column-left focus-column-right focus-window-down focus-window-up
    move-column-left move-column-right move-window-down move-window-up
    move-column-to-workspace-down move-column-to-workspace-up
    focus-workspace focus-workspace-down focus-workspace-up
    set-column-width set-window-height switch-preset-column-width
    maximize-column fullscreen-window;

  term = "${pkgs.kitty}/bin/kitty";
  menu = "${pkgs.fuzzel}/bin/fuzzel";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  swayosd = "${pkgs.swayosd}/bin/swayosd-client";

  # lock: grim grabs the frame (swaylock-effects' own --screenshots doesn't capture on
  # niri), imagemagick blurs it, swaylock shows it with the ring styling from swaylock.nix.
  lockScript = pkgs.writeShellScript "niri-lock" ''
    img="$(${pkgs.coreutils}/bin/mktemp --suffix=.png)"
    trap '${pkgs.coreutils}/bin/rm -f "$img"' EXIT
    if ${pkgs.grim}/bin/grim "$img" 2>/dev/null && [ -s "$img" ]; then
      ${pkgs.imagemagick}/bin/magick "$img" -scale 12% -blur 0x1.8 "$img"
      ${pkgs.swaylock-effects}/bin/swaylock -f -i "$img"
    else
      ${pkgs.swaylock-effects}/bin/swaylock -f
    fi
  '';
  lock = "${lockScript}";

  # region-select -> annotate -> save to ~/Pictures.
  screenshot = pkgs.writeShellScript "niri-screenshot" ''
    dir="$HOME/Pictures"
    ${pkgs.coreutils}/bin/mkdir -p "$dir"
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - \
      | ${pkgs.satty}/bin/satty --filename - \
          --output-filename "$dir/screenshot-$(${pkgs.coreutils}/bin/date +%Y%m%d-%H%M%S).png"
  '';

  # Mod+1..9 focus a workspace.
  workspaceBinds = lib.listToAttrs (lib.map (n: {
    name = "Mod+${toString n}";
    value.action = focus-workspace n;
  }) (lib.range 1 9));

  # fuzzel power menu (lock/logout/suspend/reboot/shutdown).
  powerMenu = pkgs.writeShellScript "niri-power" ''
    choice=$(printf 'lock\nlogout\nsuspend\nreboot\nshutdown' \
      | ${menu} --dmenu --prompt 'power ')
    case "$choice" in
      lock)     exec ${lock} -f ;;
      logout)   exec ${config.programs.niri.package}/bin/niri msg action quit ;;
      suspend)  exec ${pkgs.systemd}/bin/systemctl suspend ;;
      reboot)   exec ${pkgs.systemd}/bin/systemctl reboot ;;
      shutdown) exec ${pkgs.systemd}/bin/systemctl poweroff ;;
    esac
  '';

  # self-updating keybind cheatsheet parsed live from the running config.
  keysScript = pkgs.writeShellScriptBin "keys" ''
    cfg="''${XDG_CONFIG_HOME:-$HOME/.config}/niri/config.kdl"
    ${pkgs.gnused}/bin/sed -n '/^binds {/,/^}/p' "$cfg" \
      | ${pkgs.gnused}/bin/sed -E \
          -e '/^binds \{/d' -e '/^\}/d' \
          -e 's/^[[:space:]]+//' \
          -e 's#/nix/store/[a-z0-9]{32}-[^" ]*/bin/##g' \
          -e 's#/nix/store/[a-z0-9]{32}-##g' \
          -e 's/"//g' \
          -e 's/[[:space:]]*;?[[:space:]]*\}[[:space:]]*$//' \
          -e 's/[[:space:]]*\{[[:space:]]*/\t/' \
      | ${pkgs.gawk}/bin/awk -F'\t' '{printf "%-26s %s\n", $1, $2}' \
      | ${pkgs.coreutils}/bin/sort
  '';
  keysOverlay = pkgs.writeShellScript "niri-keys" ''
    ${keysScript}/bin/keys | ${menu} --dmenu --prompt 'keys  '
  '';
in
{
  programs.niri.settings = {
    input.keyboard.xkb.layout = "us";
    input.keyboard.xkb.options = "caps:escape"; # caps -> escape (vim ergonomics)

    # session env set HERE so niri and everything it spawns inherit it (a greetd ->
    # niri-session does not source profile env). native wayland for electron/firefox,
    # dark qt, and DISPLAY=:0 for the xwayland-satellite X server below.
    environment = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      QT_QPA_PLATFORMTHEME = "gtk3";
      QT_STYLE_OVERRIDE = "adwaita-dark";
      DISPLAY = ":0";
    };

    outputs."DP-4" = {
      mode = {
        width = 1920;
        height = 1080;
        refresh = 239.964;
      };
    };

    prefer-no-csd = true;

    layout = {
      gaps = 12;
      # one frame only: mauve border on, focus-ring off, so they never double up.
      border = {
        enable = true;
        width = 2;
        active.color = c.mauve;
        inactive.color = c.surface1;
      };
      focus-ring.enable = false;
      shadow = {
        enable = true;
        softness = 30;
        spread = 4;
        offset = { x = 0; y = 6; };
        color = "#00000073";
      };
    };

    # square corners, outline border (not a filled backing).
    window-rules = [ { draw-border-with-background = false; } ];

    # solid wallpaper matching the palette base. drop an image in and switch to
    # `swaybg -i /path/to/img.jpg -m fill` if you want a picture instead.
    spawn-at-startup = [
      { command = [ "${pkgs.swaybg}/bin/swaybg" "-c" (lib.removePrefix "#" c.base) ]; }
      { command = [ (lib.getExe config.services.mako.package) ]; }
    ];

    binds = {
      "Mod+Return".action = spawn term;
      "Mod+Space".action = spawn menu;
      "Ctrl+Space".action = spawn menu;
      "Mod+D".action = spawn menu;
      "Mod+Q".action = close-window;

      # h/l walk columns, j/k walk windows in a column; +Shift carries the window.
      "Mod+H".action = focus-column-left;
      "Mod+L".action = focus-column-right;
      "Mod+J".action = focus-window-down;
      "Mod+K".action = focus-window-up;
      "Mod+Left".action = focus-column-left;
      "Mod+Right".action = focus-column-right;
      "Mod+Down".action = focus-window-down;
      "Mod+Up".action = focus-window-up;
      "Mod+Shift+H".action = move-column-left;
      "Mod+Shift+L".action = move-column-right;
      "Mod+Shift+J".action = move-window-down;
      "Mod+Shift+K".action = move-window-up;
      "Mod+Shift+Left".action = move-column-left;
      "Mod+Shift+Right".action = move-column-right;
      "Mod+Shift+Down".action = focus-workspace-down;
      "Mod+Shift+Up".action = focus-workspace-up;

      "Mod+Ctrl+J".action = move-column-to-workspace-down;
      "Mod+Ctrl+K".action = move-column-to-workspace-up;
      "Mod+Ctrl+Down".action = move-column-to-workspace-down;
      "Mod+Ctrl+Up".action = move-column-to-workspace-up;

      "Mod+Alt+J".action = focus-workspace-down;
      "Mod+Alt+K".action = focus-workspace-up;
      "Mod+Alt+Down".action = focus-workspace-down;
      "Mod+Alt+Up".action = focus-workspace-up;

      "Mod+Minus".action = set-column-width "-10%";
      "Mod+Equal".action = set-column-width "+10%";
      "Mod+Shift+Minus".action = set-window-height "-10%";
      "Mod+Shift+Equal".action = set-window-height "+10%";
      "Mod+R".action = switch-preset-column-width;
      "Mod+F".action = maximize-column;
      "Mod+Shift+F".action = fullscreen-window;

      "Mod+Alt+L".action = spawn lock "-f";
      "Mod+Shift+E".action = spawn "${powerMenu}";
      "Mod+Slash".action = spawn "${keysOverlay}";

      "Print".action = spawn "${screenshot}";
      "Mod+S".action = spawn "${screenshot}";

      # media keys through swayosd (pops an on-screen bar); transport via playerctl.
      "XF86AudioRaiseVolume".action = spawn swayosd "--output-volume" "+5";
      "XF86AudioLowerVolume".action = spawn swayosd "--output-volume" "-5";
      "XF86AudioMute".action = spawn swayosd "--output-volume" "mute-toggle";
      "XF86MonBrightnessUp".action = spawn swayosd "--brightness" "+5";
      "XF86MonBrightnessDown".action = spawn swayosd "--brightness" "-5";
      "XF86AudioPlay".action = spawn playerctl "play-pause";
      "XF86AudioNext".action = spawn playerctl "next";
      "XF86AudioPrev".action = spawn playerctl "previous";
    } // workspaceBinds;
  };

  # idle-lock at 5m and lock before sleep so it never resumes unlocked.
  services.swayidle = {
    enable = true;
    timeouts = [ { timeout = 300; command = "${lock} -f"; } ];
    events.before-sleep = "${lock} -f";
  };

  # Xwayland on :0 for X11-only apps (DISPLAY=:0 is exported in the session env above).
  systemd.user.services.xwayland-satellite = {
    Unit = {
      Description = "Xwayland outside niri (X11 app support)";
      BindsTo = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "notify";
      NotifyAccess = "all";
      ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite :0";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  gtk = {
    enable = true;
    theme = { name = "adw-gtk3-dark"; package = pkgs.adw-gtk3; };
    iconTheme = { name = "Papirus-Dark"; package = pkgs.papirus-icon-theme; };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
  };

  home.packages = with pkgs; [
    swaybg grim slurp satty imagemagick wl-clipboard
    pavucontrol brightnessctl
    pkgs.playerctl # `playerctl` is shadowed by a let-binding above
    keysScript
  ];
}
