{
  flake.modules.nixos.nixos =
	{ pkgs, ... }:
	{
	  environment.systemPackages = with pkgs; [
	    lua-language-server
			rust-analyzer
			cargo
			nixd # What nvim uses for .nix
			nil # What Zed uses for .nix
			java-language-server
	  ];
	};
}
