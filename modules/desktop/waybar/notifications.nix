{
  flake.modules = {
    nixos.waybar =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          swaynotificationcenter
        ];
      };
    # Autostart if on hyprland
    homeManager.waybar.wayland.windowManager.hyprland.settings.exec-once = [
      "swaync"
    ];
  };

}
