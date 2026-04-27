{
  flake.modules = {
    nixos.vpn =
      { pkgs, lib, ... }:
      {
        options.dotfiles.vpn.enable = lib.mkEnableOption "VPN-specific dotfiles behavior";

        config = {
          dotfiles.vpn.enable = true;

          networking.firewall.checkReversePath = false;

          networking.networkmanager.enable = true;
          environment.systemPackages = with pkgs; [
            wireguard-tools
            proton-vpn-cli
          ];
        };
      };
    # Autostart if on hyprland
    homeManager.vpn =
      { lib, ... }:
      {
        options.dotfiles.vpn.enable = lib.mkEnableOption "VPN-specific dotfiles behavior";

        config = {
          dotfiles.vpn.enable = true;

          wayland.windowManager.hyprland.settings.exec-once = [
            "protonvpn connect"
          ];
        };
      };
  };
}
