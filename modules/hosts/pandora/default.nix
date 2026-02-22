{ config, ... }:
let
  modules = [
    "base"
    "openssh"
  ];
in
{
  flake = {
    nixosConfigurations.pandora = config.flake.lib.mkSystems.linux "pandora";
    modules.nixos."hosts/pandora" = {
      imports = config.flake.lib.loadNixosAndHmModuleForUser config modules;
    };
  };
}
