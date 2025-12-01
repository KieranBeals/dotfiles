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
         pavucontrol # audio control
         jq # json processor
         sdbus-cpp # Fixes some issues with loading times
       ];
     };
  };
}
