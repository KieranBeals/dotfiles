{ inputs, ... }:
{
  flake.modules.homeManager.homeManager =
	{ pkgs, ... }:
	{
	  home.packages = with pkgs; [
		  inputs.helium-browser.defaultPackage.${system}
		];
  };
}
