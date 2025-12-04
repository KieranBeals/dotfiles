{ inputs, ... }:
{
  flake.modules.homeManager.desktop =
	{ pkgs, ... }:
	{
	  home.packages = with pkgs; [
		  inputs.helium-browser.defaultPackage.${stdenv.hostPlatform.system}
		];
  };
}
