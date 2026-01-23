{
  flake.modules.homeManager.school =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        (pkgs.rstudioWrapper.override {
              packages = with pkgs.rPackages; [
                ggplot2
                moments
              ];
            })
      ];
    };
}
