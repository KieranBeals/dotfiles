{
  flake.modules.nixos.nixos =
    { pkgs, ... }:
    {
      users = {
        mutableUsers = true; # Set password with passd
        users = {
          kieran = {
            isNormalUser = true;
            description = "Kieran Beals";
            shell = pkgs.zsh;
            extraGroups = [
              "wheel"
              "input"
              "docker"
            ];
          };
        };
      };
    };
}
