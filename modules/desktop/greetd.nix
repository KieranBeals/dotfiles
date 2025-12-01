{
  flake.modules.nixos.desktop =
	{ pkgs, ... }:
	{
	  services.greetd = {
		  enable = true;
			useTextGreeter = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd hyprland";
       		user = "kieran";
	     	};
	    };
		};
  };
}
