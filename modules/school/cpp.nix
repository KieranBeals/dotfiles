{
  flake.modules.homeManager.school =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        rocmPackages.clang
      ];
    };
}
