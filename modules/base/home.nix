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
      { lib, osConfig, ... }:
      {
        home = {
          username = "kieran";
          homeDirectory = lib.mkDefault "/home/kieran";
          inherit (osConfig.system) stateVersion;
        };

        programs.home-manager.enable = true;

        xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
      };
  };
}
