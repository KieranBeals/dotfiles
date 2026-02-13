{ inputs, ... }:
{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        inputs.proton-pass-cli.packages.x86_64-linux.default
        proton-pass
      ];
    };
}
