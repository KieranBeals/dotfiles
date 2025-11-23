{ config, ... }:
let
  modules = [
    "base"
    "desktop"
    "gaming"
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
