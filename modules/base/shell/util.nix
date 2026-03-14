{
  flake.modules.nixos.nixos =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        tree
      ];

      services.upower.enable = true;
    };
}
