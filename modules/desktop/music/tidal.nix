{
  flake.modules.homeManager.desktop = {
    xdg.desktopEntries = {
      "Tidal" = {
        name = "Tidal";
        type = "Application";
        exec = "helium --app=https://tidal.com/";
      };
    };
  };
}
