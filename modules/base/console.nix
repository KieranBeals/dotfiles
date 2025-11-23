{
  flake.module.nixos.nixos = {
    services.xserver.xkb = {
      layout = "us";
	  };
	};
}
