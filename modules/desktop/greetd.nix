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

    security.pam.services = {
      greetd.fprintAuth = true;
      "greetd-password".fprintAuth = true;
      sudo.fprintAuth = true;
      login.fprintAuth = true;
    };
  };
}
