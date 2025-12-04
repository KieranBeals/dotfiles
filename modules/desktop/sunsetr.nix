{ inputs, ... }:
{
  flake.modules.nixos.desktop =
  { pkgs, ...}:
  {
    environment.systemPackages = [
      inputs.sunsetr.packages.${pkgs.stdenv.hostPlatform.system}.sunsetr
    ];
  };
}
