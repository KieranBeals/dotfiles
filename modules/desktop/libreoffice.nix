{
  flake.modules = {
    homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        libreoffice-qt-fresh
      ];
    };
  };
}
