{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        gcr
        seahorse
      ];

      services.gnome-keyring = {
        enable = true;
      };
    };
}
