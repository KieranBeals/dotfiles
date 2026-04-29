{ lib, ... }:
{
  flake.modules = {
    homeManager.hyprland =
      { pkgs, ... }:
      let
        mkMenu =
          menu:
          let
            configFile = pkgs.writeText "config.yaml" (
              lib.generators.toYAML { } {
                # https://github.com/MaxVerevkin/wlr-which-key
                anchor = "center";
                inherit menu;
              }
            );
          in
          pkgs.writeShellScriptBin "my-menu" ''
            hyprctl dispatch submap pause 
            ${lib.getExe pkgs.wlr-which-key} ${configFile} 
            hyprctl dispatch submap reset
          '';
        workspaceKeys = [
          "grave"
          "1"
          "2"
          "3"
          "4"
          "5"
          "6"
          "7"
          "8"
          "9"
          "0"
          "minus"
          "equal"
          "backspace"
        ];
        workspaceBindings =
          lib.imap0 (i: key: "$mainMod, ${key}, workspace, ${toString (i + 1)}") workspaceKeys;
        moveToWorkspaceBindings =
          lib.imap0 (i: key: "$mainMod SHIFT, ${key}, movetoworkspace, ${toString (i + 1)}") workspaceKeys;
      in
      {
        wayland.windowManager.hyprland = {

          settings = {
            "$mainMod" = "SUPER";

            bind =
              [
                (
                  "$mainMod, SPACE, exec, "
                  + lib.getExe (mkMenu [
                    {
                      key = "h";
                      desc = "Browser";
                      cmd = "helium";
                    }
                    {
                      key = "q";
                      desc = "Terminal";
                      submenu = [
                        {
                          key = "q";
                          desc = "Terminal";
                          cmd = "ghostty";
                        }
                        {
                          key = "c";
                          desc = "Edit Dotfiles";
                          cmd = "ghostty -e nvim ~/dotfiles";
                        }
                      ];
                    }
                    {
                      key = "r";
                      desc = "rofi";
                      submenu = [
                        {
                          key = "s";
                          desc = "SSH";
                          cmd = "rofi -show ssh";
                        }
                        {
                          key = "w";
                          desc = "Windows";
                          cmd = "rofi -show window";
                        }
                        {
                          key = "i";
                          desc = "Screenshots";
                          cmd = "ls -t /tmp/screenshot-*.png 2>/dev/null | rofi -dmenu -p \"Edit screenshot:\" | xargs -r satty --filename";
                        }
                      ];
                    }
                    {
                      key = "d";
                      desc = "Discord";
                      cmd = "discord";
                    }
                    {
                      key = "s";
                      desc = "Steam";
                      cmd = "steam";
                    }
                    {
                      key = "e";
                      desc = "File Manager";
                      cmd = "Thunar";
                    }
                    {
                      key = "o";
                      desc = "Notes";
                      cmd = "obsidian";
                    }

                  ])
                )

                "SUPER ALT SHIFT, escape, submap, pause"

                "$mainMod, Q, exec, ghostty"

                # Basic binds
                "$mainMod, C, killactive,"
                "$mainMod, M, exec, command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"
                "$mainMod SHIFT, F, togglefloating,"
                "$mainMod, P, pseudo,"
                "$mainMod, F, fullscreen, 0"

                # Move focus
                "$mainMod, H, movefocus, l"
                "$mainMod, L, movefocus, r"
                "$mainMod, K, movefocus, u"
                "$mainMod, J, movefocus, d"

                # Move window
                "$mainMod SHIFT, H, movewindow, l"
                "$mainMod SHIFT, L, movewindow, r"
                "$mainMod SHIFT, K, movewindow, u"
                "$mainMod SHIFT, J, movewindow, d"
              ]
              ++ workspaceBindings
              ++ moveToWorkspaceBindings
              ++ [
                # Special workspace
                "$mainMod, S, togglespecialworkspace, magic"
                "$mainMod SHIFT, S, movetoworkspace, special:magic"

                # Scroll workspaces
                "$mainMod, mouse_down, workspace, e+1"
                "$mainMod, mouse_up, workspace, e-1"

                # Screenshot
                ", PRINT, exec, FILE=/tmp/screenshot-$(date +%s).png && hyprshot -m region --freeze -o $(dirname $FILE) -f $(basename $FILE) && wl-copy < $FILE && notify-send \"Screenshot copied\" \"$(basename $FILE)\""
                "$mainMod, PRINT, exec, ls -t /tmp/screenshot-*.png 2>/dev/null | rofi -dmenu -p \"Edit screenshot:\" | xargs -r satty --filename"
              ];

            # Mouse binds
            bindm = [
              "$mainMod, mouse:272, movewindow"
              "$mainMod, mouse:273, resizewindow"
            ];

            # Media keys (repeat)
            bindel = [
              ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
              ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
              ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
              ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
              ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
              ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
            ];

            bindl = [
              ", XF86AudioNext, exec, playerctl next"
              ", XF86AudioPause, exec, playerctl play-pause"
              ", XF86AudioPlay, exec, playerctl play-pause"
              ", XF86AudioPrev, exec, playerctl previous"
            ];

          };
          extraConfig = ''
            submap = pause
              # No binds here means all keybinds are ignored
              bind = SUPER ALT SHIFT, escape, submap, reset
            submap = reset
          '';
        };
      };
  };
}
