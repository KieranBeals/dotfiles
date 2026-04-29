{ ... }:
{
  flake.modules.nixos.gaming =
    { pkgs, ... }:
    let
      pandora-launcher = pkgs.appimageTools.wrapType1 {
        pname = "pandora-launcher";
        version = "5.0.2";
        src = pkgs.fetchurl {
          url = "https://github.com/Moulberry/PandoraLauncher/releases/download/v5.0.2/PandoraLauncher-Linux-x86_64.AppImage";
          hash = "sha256-I75colvAcDwXBTLT6G9i8VCZzMqn8GACxYt27XXM1HQ=";
        };
      };
    in
    {
      environment.systemPackages = [
        (pkgs.symlinkJoin {
          name = "pandora-launcher";
          paths = [
            pandora-launcher
            (pkgs.makeDesktopItem {
              name = "pandora-launcher";
              desktopName = "Pandora Launcher";
              exec = "pandora-launcher";
              icon = "pandora-launcher";
              categories = [ "Game" ];
              keywords = [
                "minecraft"
                "launcher"
              ];
            })
          ];
        })
      ];
    };
}
