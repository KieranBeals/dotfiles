{ inputs, ... }:
{
  flake.modules.nixos.desktop = {
    imports = [ inputs.omnisearch.nixosModules.default ];

    services.omnisearch.enable = true;
  };
}
