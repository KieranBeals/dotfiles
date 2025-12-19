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
				  inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default
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
