{ config, ... }:
let
  modules = [
    "base"
    "desktop"
    "gaming"
    "messaging"
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
