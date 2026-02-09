{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };

      environment.systemPackages = with pkgs; [
        rofi
        wl-clipboard-rs

        playerctl
      ];
    };
}
