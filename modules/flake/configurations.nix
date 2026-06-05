{
  lib,
  config,
  inputs,
  ...
}:
let
  # Build a host module from three lists:
  #   systemModules - modules in the system class (nixos or darwin)
  #   homeModules   - home-manager modules applied to every user on the host
  #   users         - users that live here; each pulls its own `users/<name>` profile
  #
  # The shape is symmetric: systemModules : <class>  ::  homeModules : homeManager.
  # Missing halves are tolerated (`or { }`), so a name with only one half is a
  # no-op on the other side.
  mkHostModule =
    { class, hmModule }:
    cfg:
    {
      systemModules ? [ ],
      homeModules ? [ ],
      users ? [ ],
    }:
    {
      imports =
        (map (m: cfg.flake.modules.${class}.${m} or { }) systemModules)
        ++ [ hmModule ]
        ++ map (user: {
          home-manager.users.${user}.imports =
            [ (cfg.flake.modules.homeManager."users/${user}" or { }) ]
            ++ map (m: cfg.flake.modules.homeManager.${m} or { }) homeModules;
        }) users;
    };

  mkNixosHost = mkHostModule {
    class = "nixos";
    hmModule = inputs.home-manager.nixosModules.home-manager;
  };

  mkDarwinHost = mkHostModule {
    class = "darwin";
    hmModule = inputs.home-manager.darwinModules.home-manager;
  };

  # System closures. Each imports its class base + the host module, then stamps
  # in the per-host facts.
  mkNixos =
    system: name:
    lib.nixosSystem {
      inherit system;
      modules = [
        config.flake.modules.nixos.nixos
        config.flake.modules.nixos."hosts/${name}"
        {
          networking.hostName = lib.mkDefault name;
          nixpkgs.hostPlatform = lib.mkDefault system;
          # This value determines the NixOS release from which the default
          # settings for stateful data, like file locations and database versions
          # on your system were taken. It‘s perfectly fine and recommended to leave
          # this value at the release version of the first install of this system.
          # Before changing this value read the documentation for this option
          # (e.g. man configuration.nix or on https://search.nixos.org/options?&show=system.stateVersion&from=0&size=50&sort=relevance&type=packages&query=stateVersion).
          system.stateVersion = "26.05";
        }
      ];
    };

  mkDarwin =
    system: name:
    inputs.nix-darwin.lib.darwinSystem {
      modules = [
        config.flake.modules.darwin.darwin
        config.flake.modules.darwin."hosts/${name}"
        {
          networking.hostName = lib.mkDefault name;
          nixpkgs.hostPlatform = lib.mkDefault system;
        }
      ];
    };
in
{
  flake.lib = {
    isInstall = config: !(lib.hasAttrByPath [ "isoImage" ] config);

    mkSystems = {
      linux = mkNixos "x86_64-linux";
      linux-arm = mkNixos "aarch64-linux";
      darwin = mkDarwin "aarch64-darwin";
    };

    inherit mkNixosHost mkDarwinHost;
  };
}
