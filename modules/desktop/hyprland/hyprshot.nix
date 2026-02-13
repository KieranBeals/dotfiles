{
  flake.modules.nixos.hyprland =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        hyprshot
        satty
      ];
    };
}
