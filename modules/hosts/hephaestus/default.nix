{ config, ... }:
{
  flake = {
    nixosConfigurations.hephaestus = config.flake.lib.mkSystems.linux "hephaestus";

    modules.nixos."hosts/hephaestus" = config.flake.lib.mkNixosHost config {
      systemModules = [
        "ai"
        "apk"
        "development"
        "gaming"
        "hyprland"
        "messaging"
        "school"
        "vpn"
      ];
      homeModules = [
        "amd"
        "apk"
        "development"
        "gaming"
        "hyprland"
        "messaging"
        "school"
        "vpn"
        "work"
      ];
      users = [ "kieran" ];
    };
  };
}
