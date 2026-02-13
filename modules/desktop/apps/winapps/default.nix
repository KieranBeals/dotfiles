{ inputs, ... }:
{
  flake.modules = {
    # nixos.desktop =
    # { pkgs, ...}:
    # {
    #   environment.systemPackages = [
    #     winboat
    #     docker
    #   ];
    # };

    homeManager.desktop =
      { pkgs, ... }:
      {
        # home.file.".config/winapps/winapps.conf" = {
        #   source = ./winapps.conf;
        #   recursive = false;
        # };
        home.packages = with pkgs; [
          winboat
          docker
        ];
      };
  };
}
