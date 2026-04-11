{
  flake.modules = {
    nixos.desktop =
      { pkgs, ... }:
      {
        programs.thunar = {
          enable = true;
          plugins = with pkgs; [
            thunar-vcs-plugin
            thunar-archive-plugin
            thunar-media-tags-plugin
            thunar-volman
          ];
        };

        # needed by thundar to do removable media and more
        services.gvfs.enable = true;
      };
  };
}
