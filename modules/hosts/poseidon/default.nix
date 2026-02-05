{ config, ... }:
let
  modules = [
    "nvidia"
    "base"
    "desktop"
    "gaming"
    "messaging"
    "school"
    "development"
    "work"
  ];
in
{
  flake = {
    nixosConfigurations.poseidon = config.flake.lib.mkSystems.linux "poseidon";
    modules.nixos."hosts/poseidon" = {
      imports = config.flake.lib.loadNixosAndHmModuleForUser config modules;
    };
  };
}
