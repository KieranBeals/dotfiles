{
  flake.modules = {
    nixos.hyprland =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          rofi
          wl-clipboard-rs
          brightnessctl
          playerctl
        ];
      };
    homeManager.hyprland = {
      wayland.windowManager.hyprland = {
        settings = {
          # Monitor configuration
          monitor = [
            "eDP-1,2880x1920@120,auto,2"
            "DP-1,3840x2160@240,auto,2"
            "DP-2,3840x2160@240,auto,2"
          ];

          # XWayland
          xwayland = {
            force_zero_scaling = true;
          };

          # Variables
          "$terminal" = "ghostty";
          "$fileManager" = "thunar";
          "$menu" = "rofi -show run";
          "$notes" = "obsidian";
          "$browser" = "helium";

          # Autostart
          exec-once = [
            "waybar"
            "[workspace 1 silent] $terminal"
            "[workspace 2 silent] $notes"
            "[workspace 3 silent] $browser"
            "protonvpn connect"
          ];

          # Environment variables
          env = [
            "XCURSOR_SIZE,24"
            "HYPRCURSOR_SIZE,24"
            "ELECTRON_OZONE_PLATFORM_HINT,wayland"
          ];

          # General settings
          general = {
            gaps_in = 5;
            gaps_out = 10;
            border_size = 2;
            resize_on_border = false;
            allow_tearing = false;
            layout = "master";
          };

          # Decoration
          decoration = {
            rounding = 0;
            rounding_power = 2;
            active_opacity = 1.0;
            inactive_opacity = 0.7;

            shadow = {
              enabled = true;
              range = 4;
              render_power = 3;
            };

            blur = {
              enabled = true;
              size = 3;
              passes = 3;
              vibrancy = 0.1696;
            };
          };

          # Animations - Fast theme
          animations = {
            enabled = true;

            bezier = [
              "linear, 0, 0, 1, 1"
              "md3_standard, 0.2, 0, 0, 1"
              "md3_decel, 0.05, 0.7, 0.1, 1"
              "md3_accel, 0.3, 0, 0.8, 0.15"
              "overshot, 0.05, 0.9, 0.1, 1.1"
              "crazyshot, 0.1, 1.5, 0.76, 0.92"
              "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
              "fluent_decel, 0.1, 1, 0, 1"
              "easeInOutCirc, 0.85, 0, 0.15, 1"
              "easeOutCirc, 0, 0.55, 0.45, 1"
              "easeOutExpo, 0.16, 1, 0.3, 1"
            ];

            animation = [
              "windows, 1, 3, md3_decel, popin 60%"
              "border, 1, 10, default"
              "fade, 1, 2.5, md3_decel"
              "workspaces, 1, 3.5, easeOutExpo, slide"
              "specialWorkspace, 1, 3, md3_decel, slidevert"
            ];
          };

          # Dwindle layout
          dwindle = {
            pseudotile = true;
            preserve_split = true;
          };

          # Master layout
          master = {
            new_status = "master";
          };

          # Misc
          misc = {
            force_default_wallpaper = 0;
            disable_hyprland_logo = true;
          };

          # Input
          input = {
            kb_layout = "us";
            kb_variant = "";
            kb_model = "";
            kb_options = "";
            kb_rules = "";
            follow_mouse = 0;
            sensitivity = 0;

            touchpad = {
              natural_scroll = true;
            };
          };

          # Gestures
          gesture = [
            "3, horizontal, workspace"
          ];

          # Per-device config
          device = {
            name = "epic-mouse-v1";
            sensitivity = -0.5;
          };

          windowrule = [
            "match:class = .*, suppress_event = maximize"
            "match:class = ^$, match:title = ^$, match:xwayland = true, match:float = true, match:fullscreen = false, match:pin = false, no_focus = true"
            "match:class = hyprland-run, move = 20 monitor_h-120, float = yes"
          ];
        };
      };
    };
  };
}
