{
  flake.modules = {
	  nixos.desktop =
    { pkgs, ... }:
    {
      services.upower.enable = true;

      environment.systemPackages = with pkgs; [
	  		hyprpanel
        # optional
        power-profiles-daemon
        grimblast
        wf-recorder
      ];
    };
		homeManager.desktop = {
      programs.hyprpanel = {
			  enable = true;
        # Configure and theme almost all options from the GUI.
        # See 'https://hyprpanel.com/configuration/settings.html'.
        # Default: <same as gui>
        settings = {
				  

          # Configure bar layouts for monitors.
          # See 'https://hyprpanel.com/configuration/panel.html'.
          # Default: null
          layout = {
            bar.layouts = {
              "0" = {
                left = [ "dashboard" "workspaces" ];
                middle = [ "media" ];
                right = [ "volume" "systray" "notifications" ];
              };
            };
          };

					bar = {
            launcher.autoDetectIcon = true;
            workspaces.show_icons = true;
					};

          menus.clock = {
            time = {
              military = true;
              hideSeconds = true;
            };
            weather.unit = "metric";
          };

          menus.dashboard.directories.enabled = false;
          menus.dashboard.stats.enable_gpu = false;

          theme = {
					  font = {
              name = "CaskaydiaCove NF";
              size = "12px";
				    };
						bar = {
						  outer_spacing = "0px";
						};
          };
        };
      };
    };
  };
}
