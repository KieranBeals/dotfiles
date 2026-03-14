{
  flake.modules = {
    nixos.niri = {
      security.pam.services = {
        greetd.enableGnomeKeyring = true;
        greetd-password.enableGnomeKeyring = true;
        login.enableGnomeKeyring = true;
      };
    };

    homeManager.niri =
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
        # TODO: Run:
        # "dbus-update-activation-environment DISPLAY XAUTHORITY WAYLAND_DISPLAY"
        # "gnome-keyring-daemon --start --components=secrets"
      };
  };
}
