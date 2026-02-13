{
  flake.modules = {
    nixos.waybar =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          waybar
          blueman
          jq
          pavucontrol
        ];
      };
    homeManager.waybar = {
      home.file.".config/waybar" = {
        source = ./config;
        recursive = true;
      };

      # Autostart if on hyprland
      wayland.windowManager.hyprland.settings.exec-once = [
        "waybar"
      ];
    };
  };
}
