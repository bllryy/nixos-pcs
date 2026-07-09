# Color spine for the niri rice. Every desktop module reads config.rice.theme.colors,
# so swapping `variant` below (blood | macchiato) rethemes the whole desktop at once.
# Palettes borrowed from vmfunc/nixfiles; both share catppuccin semantic key names.
{ lib, ... }:
let
  variant = "blood"; # "blood" (near-black + muted plum, the shipped default) or "macchiato"

  palettes = {
    # Blood & Static: near-black with a muted plum-rose accent (Serial Experiments Lain).
    blood = {
      rosewater = "#d8ccd4"; flamingo = "#c8aab8"; pink = "#c79ab4";
      mauve = "#bf7593"; red = "#c0667e"; maroon = "#d07e96"; peach = "#b07e90";
      yellow = "#c4a878"; green = "#82a08c"; teal = "#6f9a98"; sky = "#8c8aa6";
      sapphire = "#9a72a0"; blue = "#8a7aa6"; lavender = "#b09cc0";
      text = "#c2b6c0"; subtext1 = "#a89ca6"; subtext0 = "#948a98";
      overlay2 = "#6e6470"; overlay1 = "#4c4450"; overlay0 = "#3c3442";
      surface2 = "#2a2430"; surface1 = "#1e1824"; surface0 = "#151019";
      base = "#0d0a0e"; mantle = "#0a070b"; crust = "#060406";
    };
    # Stock Catppuccin Macchiato.
    macchiato = {
      rosewater = "#f4dbd6"; flamingo = "#f0c6c6"; pink = "#f5bde6";
      mauve = "#c6a0f6"; red = "#ed8796"; maroon = "#ee99a0"; peach = "#f5a97f";
      yellow = "#eed49f"; green = "#a6da95"; teal = "#8bd5ca"; sky = "#91d7e3";
      sapphire = "#7dc4e4"; blue = "#8aadf4"; lavender = "#b7bfe0";
      text = "#cad3f5"; subtext1 = "#b8c0e0"; subtext0 = "#a5adcb";
      overlay2 = "#939ab7"; overlay1 = "#8087a2"; overlay0 = "#6e738d";
      surface2 = "#5b6078"; surface1 = "#494d64"; surface0 = "#363a4f";
      base = "#24273a"; mantle = "#1e2030"; crust = "#181926";
    };
  };
in
{
  options.rice.theme.colors = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    description = "Active #rrggbb palette.";
  };
  config.rice.theme.colors = palettes.${variant};
}
