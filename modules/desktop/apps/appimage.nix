{
  flake.modules.nixos.desktop = {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
