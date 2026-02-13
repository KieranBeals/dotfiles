{
  flake.modules = {
    nixos.hyprland =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          sunsetr
        ];
      };
    homeManager.hyprland = {
      wayland.windowManager.hyprland = {
        settings = {
          exec-once = [
            "sunsetr"
          ];
        };
      };
    };
  };
}
