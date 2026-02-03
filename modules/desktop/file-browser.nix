{
  flake.modules = {
    nixos.desktop = {
      programs.thunar.enable = true;
      # needed by thundar to do removable media and more
      services.gvfs.enable = true;
    };
  };
}
