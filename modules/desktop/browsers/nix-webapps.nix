{ inputs, ... }:
{
  flake.modules.nixos.desktop = {
    nixpkgs.overlays = [
      inputs.nix-webapps.overlays.lib
    ];
  };
}
