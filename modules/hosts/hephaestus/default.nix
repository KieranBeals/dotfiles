{ config, ... }:
let
  modules = [
    "base"
    "desktop"
    "hyprland"
    "gaming"
    "messaging"
    "school"
    "development"
    "amd"
    "vpn"
    "work"
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
