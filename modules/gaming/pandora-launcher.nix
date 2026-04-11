{ ... }:
{
  flake.modules.nixos.gaming =
    { pkgs, ... }:
    let
      pandora-launcher = pkgs.appimageTools.wrapType1 {
        pname = "pandora-launcher";
        version = "4.1.0";
        src = pkgs.fetchurl {
          url = "https://github.com/Moulberry/PandoraLauncher/releases/download/v4.1.0/PandoraLauncher-Linux-x86_64.AppImage";
          hash = "sha256-20jSeUjxJCpolZA55M6jopMQqeE4xOdprtW+fwGq2Ac=";
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
