{ inputs, ... }:
{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        inputs.tidaLuna.packages.${system}.default
      ];
    };
}
