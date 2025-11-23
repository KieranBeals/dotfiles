{
  flake.modules.nixos.nixos =
    { pkgs, ... }:
    {
      users = {
        mutableUsers = true; # Set password with passd 
        users = {
          kieran = {
            isNormalUser = true;
            description = "Karun Sandhu";
            shell = pkgs.fish;
            extraGroups = [
              "wheel"
              "input"
            ];
          };
        };
      };
    };
}
