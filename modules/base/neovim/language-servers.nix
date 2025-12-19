{
  flake.modules.nixos.nixos = 
	{ pkgs, ... }: 
	{
	  environment.systemPackages = with pkgs; [
	    lua-language-server
			rust-analyzer
			nixd
			java-language-server
	  ];
	};
}
