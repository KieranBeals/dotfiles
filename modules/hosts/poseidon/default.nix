{ config, ... }:
let
  modules = [
    "nvidia"
    "base"
    "ai"
    "hyprland"
    "apk"
    "messaging"
    "school"
    "gaming"
    "development"
    "work"
    "vpn"
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
