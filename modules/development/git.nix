{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.homeManager.development = {
    programs = {
      git = {
        enable = true;
        userEmail = {
          inherit (meta.users.kieran) email;
        };
        userName = {
          inherit (meta.users.kieran) name;
        };
        aliases = {
          a = "add";
          b = "branch";
          c = "commit";
          ca = "commit --amend";
          cm = "commit -m";
          co = "checkout";
          d = "diff";
          ds = "diff --staged";
          l = "log --oneline";
          ll = "log";
          p = "push";
          pf = "push --force-with-lease";
          pl = "pull";
          r = "rebase";
          s = "status --short";
          ss = "status";
          sw = "switch";
          # W alias by Karun
          forgor = "commit --amend --no-edit";
          graph = "log --all --decorate --graph --oneline";
          oops = "checkout --";
        };
      };

      # Syntax-highlighting
      delta = {
        enable = true;
        enableGitIntegration = true;
      };
    };
  };
}
