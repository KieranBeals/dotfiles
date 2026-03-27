{
  flake.modules = {
    nixos.school =
      { pkgs, ... }:
      {
        services.languagetool.enable = true;

        environment.systemPackages = with pkgs; [
          obsidian
        ];

        # Obsidian has not updated?
        # TODO: Remove
        nixpkgs.config.permittedInsecurePackages = [
          "electron-38.8.4"
        ];
      };
  };
}
