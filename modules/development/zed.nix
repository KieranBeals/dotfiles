{
  flake.modules.homeManager.desktop =
	{ pkgs, ... }:
	{
	  home.packages = with pkgs; [
	    zed-editor
		];
  };
}
