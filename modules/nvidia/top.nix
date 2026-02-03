{
  flake.modules.homeManager.nvidia =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        btop-cuda
      ];
    };
}
