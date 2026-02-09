{
  flake.modules = {
    nixos.school =
      { pkgs, ... }:
      {
        programs.vscode = {
          enable = true;
          extensions = with pkgs.vscode-extensions; [
            vscodevim.vim
            ms-vscode-remote.remote-ssh
            ms-vscode.remote-explorer
            ms-vscode.cpptools-extension-pack
          ];
        };
      };
    homeManager.school =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          rocmPackages.clang
          vscode
        ];
      };
  };
}
