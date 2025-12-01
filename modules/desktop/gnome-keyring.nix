{
  flake.modules = {
    nixos.desktop = {
      security.pam.services = {
        greetd.enableGnomeKeyring = true;
        greetd-password.enableGnomeKeyring = true;
        login.enableGnomeKeyring = true;
      };
    };

    homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        gcr
        seahorse
        gnome-keyring
      ];

      services.gnome-keyring = {
        enable = true;
      };
    };
  };
}
