{ config, ... }:
let
  modules = [
    "ai"
    "base"
    "hyprland"
    "messaging"
    "school"
    "gaming"
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
