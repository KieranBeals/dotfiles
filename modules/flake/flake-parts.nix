# This allows multiple files to define 
# flake.modules and have them all merge together
{ lib, inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  options.flake = {
    meta = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.anything;
    };
  };
}
