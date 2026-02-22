{
  flake.modules.nixos.nixos = {
    programs.ssh = {
      enable = true;

      matchBlocks = {
        "*" = {
          identityFile = "~/.ssh/id_ed25519";
          hashKnownHosts = true;
          serverAliveInterval = 60;
          forwardAgent = false;
        };
      };
    };
  };
}
