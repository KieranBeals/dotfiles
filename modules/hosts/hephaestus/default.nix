{ config, ... }:
let
  modules = [
	  "base"
    "desktop"
    "gaming"
    "messaging"
    "school"
    "development"
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
