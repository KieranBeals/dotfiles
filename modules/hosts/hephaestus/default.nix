{ config, ... }:
let
  modules = [
    "base"
    "desktop"
    "gaming"
    "messaging"
    "school"
    "development"
    "amd"
  ];
in
{
  flake = {
    nixosConfigurations.hephaestus = config.flake.lib.mkSystems.linux "hephaestus";
    modules.nixos."hosts/hephaestus" = {
      imports = config.flake.lib.loadNixosAndHmModuleForUser config modules;
    };
  };
}
