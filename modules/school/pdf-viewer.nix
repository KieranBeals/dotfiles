{
  flake.modules = {
    nixos.school =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          sioyek
        ];
      };
  };
}
