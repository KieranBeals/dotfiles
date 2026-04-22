{ ... }:
{
  flake.modules.nixos.ai =
    { pkgs, ... }:
    let
      dpcode = pkgs.appimageTools.wrapType2 {
        pname = "dpcode";
        version = "0.0.34";
        src = pkgs.fetchurl {
          url = "https://github.com/Emanuele-web04/dpcode/releases/download/v0.0.34/DP-Code-0.0.34-x86_64.AppImage";
          hash = "sha256-v4XaBQz2Ha0oqTTMJcVhdE2g0OMszBAeCgbXww0DjQA=";
        };
      };

      icon = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/Emanuele-web04/dpcode/main/assets/prod/logo.svg";
        hash = "sha256-+87dvO63UTb7jixwLPD+RZ0VO2Kau9piYqY9fExl5nM=";
      };
    in
    {
      environment.systemPackages = [
        (pkgs.symlinkJoin {
          name = "dpcode";
          paths = [
            dpcode
            (pkgs.makeDesktopItem {
              name = "dpcode";
              desktopName = "DP Code";
              exec = "dpcode";
              icon = "dpcode";
              categories = [ "Development" ];
              keywords = [
                "codex"
                "claude"
                "ai"
                "coding"
                "dpcode"
              ];
            })
          ];
          postBuild = ''
            mkdir -p $out/share/icons/hicolor/scalable/apps
            cp ${icon} $out/share/icons/hicolor/scalable/apps/dpcode.svg
          '';
        })
      ];
    };
}
