{
  flake.modules = {
    homeManager.desktop =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          mission-center
        ];
      };
  };
}
