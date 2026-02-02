{
  flake.modules = {
	  nixos.desktop = 
	  { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        ghostty
      ];
    };
		homeManager.desktop = {
      home.file.".config/ghostty/config" = {
        source = ./config;
      };
		};
  };
}
