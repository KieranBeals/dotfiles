{
  flake.modules = {
    nixos.hyprland =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          swww
        ];
      };

    homeManager.hyprland.wayland.windowManager.hyprland.settings = {
      exec-once = [
        "swww-daemon"
        "swww img dotfiles/walls/black.webp --transition-type none"
        "swww img dotfiles/walls/nature.jpg --transition-fps 240 --transition-type grow"
      ];
    };
  };
}
