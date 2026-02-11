{
  flake.modules.nixos.vpn =
    { pkgs, ... }:
    {
      networking.firewall.checkReversePath = false;
      environment.systemPackages = with pkgs; [
        wireguard-tools
        proton-vpn-cli
      ];
    };
}
