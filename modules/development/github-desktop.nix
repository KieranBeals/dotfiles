{
  flake.modules.homeManager.development =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.stable.github-desktop
      ];
    };
}
