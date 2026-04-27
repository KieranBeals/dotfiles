{ ... }:
{
  flake.modules.nixos.ai =
    { pkgs, ... }:
    let
      t3code = pkgs.appimageTools.wrapType2 {
        pname = "t3code";
        version = "0.0.21";
        src = pkgs.fetchurl {
          url = "https://github.com/pingdotgg/t3code/releases/download/v0.0.21/T3-Code-0.0.21-x86_64.AppImage";
          hash = "sha256-eQCfskpl+JJOyaYY7ogYCi0ZCuWNRcEpseWMniS/LCQ=";
        };
      };

      icon = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/pingdotgg/t3code/main/assets/prod/logo.svg";
        hash = "sha256-+87dvO63UTb7jixwLPD+RZ0VO2Kau9piYqY9fExl5nM=";
      };
    in
    {
      environment.systemPackages = [
        (pkgs.symlinkJoin {
          name = "t3code";
          paths = [
            t3code
            (pkgs.makeDesktopItem {
              name = "t3code";
              desktopName = "T3 Code";
              exec = "t3code";
              icon = "t3code";
              categories = [ "Development" ];
              keywords = [
                "claude"
                "codex"
                "ai"
                "coding"
              ];
            })
          ];
          postBuild = ''
            mkdir -p $out/share/icons/hicolor/scalable/apps
            cp ${icon} $out/share/icons/hicolor/scalable/apps/t3code.svg
          '';
        })
        pkgs.claude-code
        pkgs.codex
      ];
    };
}
