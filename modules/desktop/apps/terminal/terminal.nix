{
  flake.modules = {
    nixos.desktop =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          ghostty
        ];
      };
    homeManager.desktop = {
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "x-scheme-handler/terminal" = "com.mitchellh.ghostty.desktop";
        };
      };

      home.file = {
        ".config/ghostty/config".source = ./config;

        ".config/xfce4/helpers.rc".text = ''
          TerminalEmulator=ghostty
        '';

        ".local/share/xfce4/helpers/ghostty.desktop".text = ''
          [Desktop Entry]
          NoDisplay=true
          Version=1.0
          Encoding=UTF-8
          Type=X-XFCE-Helper
          Name=Ghostty
          X-XFCE-Category=TerminalEmulator
          X-XFCE-Commands=ghostty --window-inherit-working-directory=false --working-directory=inherit
          X-XFCE-CommandsWithParameter=ghostty --window-inherit-working-directory=false --working-directory=inherit -e "%s"
          Icon=com.mitchellh.ghostty
        '';
      };
    };
  };
}
