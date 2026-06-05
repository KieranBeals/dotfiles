{ config, ... }:
{
  flake = {
    # PLACEHOLDER NAME. Rename `hermes` to whatever you call this MacBook, or set
    # the machine's hostname to match so `nh darwin switch` auto-selects it.
    # Otherwise target it explicitly: `nh darwin switch . -H hermes`.
    darwinConfigurations.hermes = config.flake.lib.mkSystems.darwin "hermes";

    modules.darwin."hosts/hermes" = config.flake.lib.mkDarwinHost config {
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
