{ lib, ... }:
{
  flake.modules.nixos.nixos =
	  { config, ... }:
		{
      time.timeZone = "America/Toronto";
		};
}
