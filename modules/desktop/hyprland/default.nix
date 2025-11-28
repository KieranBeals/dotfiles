{
  flake.modules = {
	  nixos.desktop =
		{
      programs.hyprland = {
        enable = true;
				xwayland.enable = true;
			};

			# Tell apps to use Wayland
			environment.sessionVariables.NIXOS_OZONE_WL = "1";
		};

    homeManager.desktop =
   { pkgs, ... }:
   {
       home.file.".config/hypr/hyprland.conf" = {
         source = ./hyprland-config/hyprland.conf;
         recursive = false;
       };

       home.file.".config/swaync" = {
         source = ./swaync;
         recursive = true;
       };

       home.packages = with pkgs; [
         ghostty
         rofi
         brightnessctl
         blueman
         hyprpicker
         hyprpaper
         nerd-fonts.jetbrains-mono
         swaynotificationcenter
         slurp
         grim
         wl-clipboard
       ];
     };};
}
