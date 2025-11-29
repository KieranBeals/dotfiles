{
  flake.modules.homeManager.amd =
  { pkgs, ... }:
  {
    home.packages = with pkgs; [
      btop-rocm
    ];
  };
}
