{
  flake.modules = {
    nixos.waybar =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          waybar
          blueman
          jq
          pavucontrol
        ];
      };
    homeManager.waybar = {
      home.file.".config/waybar" = {
        source = ./config;
        recursive = true;
      };
    };
  };
}
