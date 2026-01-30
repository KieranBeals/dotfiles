{ inputs, ... }:
{
  flake.modules.nixos.desktop = 
	{ pkgs, ... }:
  {
    environment.systemPackages = with pkgs; [
      inputs.awww.packages.${stdenv.hostPlatform.system}.awww
    ];
  };
}
