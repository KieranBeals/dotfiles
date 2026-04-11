{
  flake.modules.nixos.nixos =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        tree
        ffmpeg
      ];

      services.upower.enable = true;
    };
}
