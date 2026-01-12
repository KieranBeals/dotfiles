{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.nix-webapps-lib.mkChromiumApp {
          appName = "google-tidal";
          categories = [
            "Music"
          ];
          class = "chrome-tidal.com__-TidalProfile";
          desktopName = "Tidal";
          icon = ./tidal-logo.svg;
          profile = "TidalProfile";
          url = "https://tidal.com/";
        })
      ];
    };
}
