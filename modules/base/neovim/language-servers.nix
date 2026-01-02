{
  flake.modules.nixos.nixos =
	{ pkgs, ... }:
	{
	  environment.systemPackages = with pkgs; [
	    lua-language-server
			rust-analyzer
			cargo
			nixd
			java-language-server
	  ];
	};
}
