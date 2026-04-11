{
  flake.modules = {
    nixos.hyprland = {
      services.hypridle.enable = true;

      security.pam.services.hyprlock = {
        fprintAuth = false;
      };
    };

    homeManager.hyprland = {
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "pidof hyprlock || hyprlock";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };

          listener = [
            {
              timeout = 2 * 60;
              on-timeout = "brightnessctl -s set 10";
              on-resume = "brightnessctl -r";
            }
            {
              timeout = 5 * 60;
              on-timeout = "pidof hyprlock || hyprlock";
            }
            {
              timeout = 10 * 60;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
            {
              timeout = 20 * 60;
              on-timeout = "systemctl suspend";
            }
          ];
        };
      };

      wayland.windowManager.hyprland.settings.exec-once = [
        "hypridle"
      ];
    };
  };
}
