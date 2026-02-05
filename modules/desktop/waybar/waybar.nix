{
  flake.modules = {
    nixos.desktop =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          waybar
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
