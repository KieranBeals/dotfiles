{
  flake.modules = {
    homeManager.desktop =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          r2modman
        ];
      };
  };
}
