{
  flake.modules.homeManager.development =
    { pkgs, lib, ... }:
    {
      # github-desktop is Linux-only, so only add it there. This keeps the
      # `development` home module portable to macOS (git/delta still follow you).
      home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        pkgs.stable.github-desktop
      ];
    };
}
