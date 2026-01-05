{ inputs, ... }:
{
  flake.modules = {
    nixos.desktop =
      { pkgs, ... }:
      {
        services.xserver.enable = true;
        services.displayManager.sddm.enable = true;
        services.displayManager.sddm.wayland.enable = true;
        services.desktopManager.plasma6.enable = true;

        xdg.portal = {
          enable = true;
          xdgOpenUsePortal = true;

          extraPortals = with pkgs.kdePackages; [
            xdg-desktop-portal-kde # Qt 6 version for Plasma 6
          ];

          config = {
            kde = {
              default = [
                "kde"
                "gtk"
              ];
              "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
              "org.freedesktop.impl.portal.Screenshot" = [ "kde" ];
              "org.freedesktop.impl.portal.ScreenCast" = [ "kde" ];
            };
          };
        };
      };

    homeManager.desktop =
      { ... }:
      {
        imports = [
          inputs.plasma-manager.homeModules.plasma-manager
        ];

        # Now you can use plasma-manager options
        programs.plasma = {
          enable = true;

          # input = {
          #   touchpad = {
          #     enabled = true;
          #     naturalScrolling = true;
          #   };
          # };

          workspace = {
            theme = "breeze-dark";
            colorScheme = "BreezeDark";
            # wallpaper = "/path/to/wallpaper.png";
          };

          panels = [
            {
              location = "bottom";
              height = 44;
              widgets = [
                "org.kde.plasma.kickoff"
                "org.kde.plasma.icontasks"
                "org.kde.plasma.systemtray"
                "org.kde.plasma.digitalclock"
              ];
            }
          ];

          shortcuts = {
            "kwin"."Window Close" = "Meta+C";
            "kwin"."Overview" = "Meta+Tab";
          };

          overrideConfig = true;
        };
      };
  };
}
