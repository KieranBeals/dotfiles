{
  flake.modules = {
    nixos.hyprland = {
      security.pam.services = {
        greetd.enableGnomeKeyring = true;
        greetd-password.enableGnomeKeyring = true;
        login.enableGnomeKeyring = true;
      };
    };

    homeManager.hyprland =
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
        wayland.windowManager.hyprland = {
          settings = {
            exec-once = [
              "dbus-update-activation-environment DISPLAY XAUTHORITY WAYLAND_DISPLAY"
              "gnome-keyring-daemon --start --components=secrets"
            ];
          };
        };
      };
  };
}
