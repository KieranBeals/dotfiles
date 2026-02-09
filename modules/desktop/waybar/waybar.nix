{
  flake.modules = {
    nixos.desktop =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          waybar
          blueman
          jq
          pavucontrol
        ];
      };
    homeManager.desktop = {
      home.file.".config/waybar" = {
        source = ./config;
        recursive = true;
      };
    };
  };
}
