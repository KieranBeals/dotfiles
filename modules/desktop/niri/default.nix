{ config, lib, ... }:
let
  flakemodules = config.flake.modules;
in
{
  flake.modules = {
    nixos.niri =
      { pkgs, ... }:
      {
        imports = [
          flakemodules.nixos.waybar
          flakemodules.nixos.desktop
        ];

        programs.niri = {
          enable = true;
        };
        environment.systemPackages = with pkgs; [
          rofi
          wl-clipboard-rs
          brightnessctl
          playerctl
        ];
      };

    homeManager.niri =
      { pkgs, ... }:
      let
        mkMenu =
          menu:
          let
            configFile = pkgs.writeText "config.yaml" (
              lib.generators.toYAML { } {
                anchor = "center";
                inherit menu;
              }
            );
          in
          # No submap in niri — wlr-which-key grabs keyboard itself
          pkgs.writeShellScriptBin "menu" ''
            ${lib.getExe pkgs.wlr-which-key} ${configFile}
          '';
      in
      {
        imports = [
          flakemodules.homeManager.waybar
          flakemodules.homeManager.desktop
        ];

        home.sessionVariables.NIXOS_OZONE_WL = "1";

        home.packages = [
          (mkMenu [
            {
              key = "h";
              desc = "Browser";
              cmd = "helium";
            }
            {
              key = "q";
              desc = "Terminal";
              submenu = [
                {
                  key = "q";
                  desc = "Terminal";
                  cmd = "ghostty";
                }
                {
                  key = "c";
                  desc = "Edit Dotfiles";
                  cmd = "ghostty -e nvim ~/dotfiles";
                }
              ];
            }
            {
              key = "r";
              desc = "rofi";
              submenu = [
                {
                  key = "s";
                  desc = "SSH";
                  cmd = "rofi -show ssh";
                }
                {
                  key = "w";
                  desc = "Windows";
                  cmd = "rofi -show window";
                }
                {
                  key = "i";
                  desc = "Screenshots";
                  cmd = "ls -t /tmp/screenshot-*.png 2>/dev/null | rofi -dmenu -p \"Edit screenshot:\" | xargs -r satty --filename";
                }
              ];
            }
            {
              key = "d";
              desc = "Discord";
              cmd = "discord";
            }
            {
              key = "s";
              desc = "Steam";
              cmd = "steam";
            }
            {
              key = "e";
              desc = "File Manager";
              cmd = "Thunar";
            }
            {
              key = "o";
              desc = "Notes";
              cmd = "obsidian";
            }
          ])
        ];

        dconf.settings = {
          "org/gnome/desktop/wm/preferences" = {
            button-layout = "':'";
          };
        };
      };
  };
}
