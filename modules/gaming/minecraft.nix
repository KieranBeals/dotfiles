{
  flake.modules = {
    homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # Modrinth does not work at all
        prismlauncher
        glfw
      ];
    };
  };
}
