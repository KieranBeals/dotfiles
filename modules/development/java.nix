{
  flake.modules = {
    homeManager.desktop =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          # javaPackages.compiler.openjdk21
          jdk25_headless
        ];
      };
  };
}
