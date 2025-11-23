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
				  inputs.neovim-nightly-overlay.packages.${system}.default
					lua-language-server
					nixd
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
