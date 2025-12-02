{ inputs, ... }:
{
  flake.modules.nixos.desktop =
  { pkgs, ...}:
  {
    environment.systemPackages = [
      inputs.sunsetr.packages.${pkgs.system}.sunsetr
    ];
  };
}
