{
  flake.module.nixos.laptop = {
    networking.networkmanager.enable = true;
    networking.networkmanager.wifi.owersave = false; # EDUROAM :)))
	};
}
