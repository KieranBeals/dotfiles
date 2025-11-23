{
  flake.modules.nixos.desktop = 
	{
	  services.pipewire = {
		  enable = true;
			alsa = {
			  enable = true;
			  support32Bit = true;
			};
			pulse.enable = true;
		};
  };  
}
