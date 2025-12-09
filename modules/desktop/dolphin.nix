{
  flake.modules = {
    nixos.desktop =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        kdePackages.dolphin

        # Icons
        kdePackages.qtsvg

        # For network shares
        kdePackages.kio
        kdePackages.kio-fuse # to mount remote filesystems via FUSE
        kdePackages.kio-extras # extra protocols support (sftp, fish and more)

        kdePackages.xdg-desktop-portal-kde
        kdePackages.plasma-integration
      ];

      xdg.portal = {
        enable = true;
          extraPortals = with pkgs; [
            xdg-desktop-portal-hyprland
            xdg-desktop-portal-gtk
            kdePackages.xdg-desktop-portal-kde
          ];
          configPackages = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
          config.common.FileChooser = [ "kde" ];
      };
    };
    homeManager.desktop = {
      home.sessionVariables = {
        SAL_USE_VCLPLUGIN = "kf6";   # The magic switch
        GTK_USE_PORTAL = "1";        # Force other GTK apps to try portals
      };
    };
  };
}
