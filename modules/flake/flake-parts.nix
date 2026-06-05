# This allows multiple files to define
# flake.modules and have them all merge together
{ lib, inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  options.flake = {
    meta = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.anything;
    };

    # This flake-parts version knows `nixosConfigurations` but not
    # `darwinConfigurations`, so declare it to promote it to a real flake output.
    darwinConfigurations = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.unspecified;
      default = { };
    };
  };
}
