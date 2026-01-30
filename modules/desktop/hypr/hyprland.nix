{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };

      environment.systemPackages = with pkgs; [
        kitty
        rofi
				wl-clipboard-rs
      ];
    };
}
