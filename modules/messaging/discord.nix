{
  flake.modules.homeManager.messaging =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        discord
        # equibop
      ];
    };
}
