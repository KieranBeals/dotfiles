{ config, ... }:
{
  flake = {
    nixosConfigurations.poseidon = config.flake.lib.mkSystems.linux "poseidon";

    modules.nixos."hosts/poseidon" = config.flake.lib.mkNixosHost config {
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
        "apk"
        "development"
        "gaming"
        "hyprland"
        "messaging"
        "nvidia"
        "school"
        "vpn"
        "work"
      ];
      users = [ "kieran" ];
    };
  };
}
