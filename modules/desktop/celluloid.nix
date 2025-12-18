{
  flake.modules = {
    homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        celluloid # Media viewer
      ];
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "video/mp4" = [ "org.gnome.Celluloid.desktop" ];
          "video/x-matroska" = [ "org.gnome.Celluloid.desktop" ];
          "video/webm" = [ "org.gnome.Celluloid.desktop" ];
          "video/x-msvideo" = [ "org.gnome.Celluloid.desktop" ];
          "audio/mpeg" = [ "org.gnome.Celluloid.desktop" ];
          "audio/flac" = [ "org.gnome.Celluloid.desktop" ];
          "audio/x-wav" = [ "org.gnome.Celluloid.desktop" ];
        };
      };
    };
  };
}
