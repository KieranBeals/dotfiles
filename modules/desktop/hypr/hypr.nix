{
  flake.modules.homeManager.desktop = {
    home.file.".config/hypr" = {
      source = ./config;
      recursive = true;
    };
  };
}
