{
  flake.modules.nixos.apk =
    { pkgs, ... }:
    {
      virtualisation.waydroid.enable = true;

      networking.nftables.enable = true;

      networking.firewall.trustedInterfaces = [ "waydroid0" ];

      environment.systemPackages = with pkgs; [
        dnsmasq
      ];
    };
}
