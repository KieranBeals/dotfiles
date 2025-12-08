{ inputs, ... }:
{
  flake.modules = {
    nixos.gaming =
    { pkgs, ... }:
    {
      services.udev.packages = [ inputs.x1-control-panel.packages.${pkgs.stdenv.hostPlatform.system}.default ];
    };

    homeManager.gaming =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.x1-control-panel.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
  };
}
