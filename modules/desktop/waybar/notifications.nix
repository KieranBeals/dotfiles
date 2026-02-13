{
  flake.modules.nixos.waybar =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        swaynotificationcenter
      ];
    };
}
