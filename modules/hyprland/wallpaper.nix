{
  flake.modules.nixos.hyprland =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        swww
      ];
    };
}
