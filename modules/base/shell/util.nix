{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        tree
      ];

      services.upower.enable = true;
    };
}
