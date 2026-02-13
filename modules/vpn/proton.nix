{
  flake.modules = {
    nixos.vpn =
      { pkgs, ... }:
      {
        networking.firewall.checkReversePath = false;

        networking.networkmanager.enable = true;
        environment.systemPackages = with pkgs; [
          wireguard-tools
          proton-vpn-cli
        ];
      };
    # Autostart if on hyprland
    homeManager.vpn.wayland.windowManager.hyprland.settings.exec-once = [
      "protonvpn connect"
    ];
  };
}
