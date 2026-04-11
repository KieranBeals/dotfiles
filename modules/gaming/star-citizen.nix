{ inputs, ... }:
{
  flake.modules.nixos.gaming =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        inputs.nix-citizen.packages.${pkgs.stdenv.hostPlatform.system}.rsi-launcher
      ];
    };
}
