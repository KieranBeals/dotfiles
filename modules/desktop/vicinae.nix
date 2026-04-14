{
  flake.modules = {
    nixos.hyprland =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.vicinae ];
      };
    homeManager.hyprland = {
      wayland.windowManager.hyprland.settings = {
        exec-once = [ "vicinae server" ];
        bind = [
          "$mainMod, R, exec, vicinae open"
          "$mainMod, V, exec, vicinae vicinae://launch/clipboard/history"
        ];
      };
    };
  };
}
