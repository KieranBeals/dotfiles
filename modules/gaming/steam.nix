{
  flake.modules.nixos.gaming =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };
      environment.systemPackages = with pkgs; [
        protonup-qt
      ];
    };
}
