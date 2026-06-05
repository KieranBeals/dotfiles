{ config, ... }:
{
  flake = {
    # Apollo — the beautiful, sealed, "just works" Mac. Foil to Hephaestus the
    # rugged, repairable smith (the Framework). Set this machine's hostname to
    # `apollo` so `nh darwin switch` auto-selects it, or target it explicitly:
    # `nh darwin switch . -H apollo`.
    darwinConfigurations.apollo = config.flake.lib.mkSystems.darwin "apollo";

    modules.darwin."hosts/apollo" = config.flake.lib.mkDarwinHost config {
      # No darwin-class system modules yet. As you add Mac system config
      # (homebrew casks, system.defaults, launchd agents), give it a
      # `flake.modules.darwin.<name>` and list it here — same shape as the
      # NixOS hosts' `systemModules`.
      systemModules = [ ];

      # Home-manager modules applied to this host's users. Start with only what
      # is known to work on macOS; the WM/Linux-coupled ones (hyprland, vpn,
      # messaging, school's rocm clang…) are NOT portable yet.
      homeModules = [
        "development"
      ];

      users = [ "kieran" ];
    };
  };
}
