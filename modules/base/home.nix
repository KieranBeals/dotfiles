{
  flake.modules = {
    nixos.nixos = {
      home-manager = {
        backupFileExtension = "backup";
        overwriteBackup = true; # TODO Change this
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };

    homeManager.homeManager =
      { lib, pkgs, ... }:
      {
        home = {
          username = "kieran";
          # OS-aware so the same profile activates on NixOS and macOS. (darwin's
          # system.stateVersion is an int, so we can't `inherit` it into the
          # home-manager stateVersion, which is a release string.)
          homeDirectory = lib.mkDefault (
            if pkgs.stdenv.hostPlatform.isDarwin then "/Users/kieran" else "/home/kieran"
          );
          stateVersion = lib.mkDefault "26.05";
        };

        programs.home-manager.enable = true;

        xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
      };
  };
}
