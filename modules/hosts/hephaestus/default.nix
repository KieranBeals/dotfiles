{ config, ... }:
let
  modules = [
    "base"
    "hyprland"
    "messaging"
    "school"
    "development"
    "amd"
    "apk"
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
