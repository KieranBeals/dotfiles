{
  flake.modules = {
    nixos.hyprland =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.vlc ];
      };
  };
}
