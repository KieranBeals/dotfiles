{ inputs, ... }:
{
  flake.modules = {
    nixos.nixos = {
      programs.neovim.enable = true;
    };

    homeManager.homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          neovim
          ripgrep
          luarocks
          rustup
        ];

        home.file = {
          ".config/nvim" = {
            source = ./config;
            recursive = true;
          };
        };
      };
  };
}
