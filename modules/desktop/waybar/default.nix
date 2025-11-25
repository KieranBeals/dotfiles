{
  flake.modules = {
    homeManager.desktop =
    { pkgs, ... }:
    {
       home.file.".config/waybar" = {
         source = ./waybar-config;
         recursive = true;
       };

       home.packages = with pkgs; [
         waybar
       ];
     };
  };
}
