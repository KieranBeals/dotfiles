{ config, ... }:
let
  flakemodules = config.flake.modules;
in
{
  flake.modules = {

    nixos.hyprland = {
      imports = [
        flakemodules.nixos.waybar
        flakemodules.nixos.desktop
      ];

      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        withUWSM = true;
      };
    };

    homeManager.hyprland =
      { config, ... }:
      {
        imports = [
          flakemodules.homeManager.waybar
          flakemodules.homeManager.desktop
        ];

        wayland.windowManager.hyprland = {
          enable = true;
          systemd.enable = false;

          package = null;
          portalPackage = null;

          settings.permission = map (
            plugin: plugin + "/lib/lib${plugin.pname}.so, plugin, allow"
          ) config.wayland.windowManager.hyprland.plugins;
        };

        services.network-manager-applet.enable = true;

        # home.file.".config/hypr/scripts" = {
        #   source = ./scripts;
        # };

        dconf.settings = {
          "org/gnome/desktop/wm/preferences" = {
            button-layout = "':'";
          };
        };
      };
  };
}
