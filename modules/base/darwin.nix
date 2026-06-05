{
  self,
  inputs,
  ...
}:
{
  # The darwin counterpart of `nixos.nixos` (see ./default.nix): the always-on
  # baseline every Mac host imports. Mirrors the NixOS base where an analog
  # exists, and simply omits the Linux-only bits (boot, systemd, networkmanager…).
  flake.modules.darwin.darwin =
    { pkgs, ... }:
    {
      # --- Nix daemon ---------------------------------------------------------
      # NOTE: this machine looks like a Determinate Systems install (nix lives at
      # /nix/var/nix/profiles/default). Determinate manages the daemon itself, so
      # if `darwin-rebuild`/`nh` complains about nix.* ownership, set
      # `nix.enable = false;` here and let Determinate own the settings.
      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [
          "root"
          "@admin"
        ];
      };

      nixpkgs = {
        config.allowUnfree = true;
        overlays = builtins.attrValues self.overlays;
      };

      # nh, same as NixOS. This nix-darwin version has no `programs.nh` module,
      # so install the binary and point it at the dotfiles via $NH_FLAKE (nh
      # reads it as the default target, so `nh darwin switch` works anywhere).
      environment.systemPackages = [
        inputs.nh.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
      environment.variables.NH_FLAKE = "/Users/kieran/Documents/dotfiles";

      # Home-manager wiring, mirroring the NixOS base (./home.nix).
      home-manager = {
        backupFileExtension = "backup";
        useGlobalPkgs = true;
        useUserPackages = true;
      };

      users.users.kieran.home = "/Users/kieran";
      # Required by recent nix-darwin for user-scoped options & home-manager.
      system.primaryUser = "kieran";

      system.stateVersion = 6;
    };
}
