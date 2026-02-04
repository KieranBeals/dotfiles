{
  flake.modules = {
    nixos.school =
      { pkgs, ... }:
      {
        services.languagetool.enable = true;

        environment.systemPackages = with pkgs; [
          obsidian
        ];
      };
  };
}
