{
  flake.modules = {
    nixos.hyprland =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          swww
        ];
      };

    homeManager.hyprland =
      { pkgs, ... }:
      {
        wayland.windowManager.hyprland.settings =
          let
            random-wallpaper = pkgs.writeShellScript "randwall" ''
              while true; do
                img="$(find ~/Pictures/Wallpapers -type f \( -name '*.webp' -o -name '*.png' -o -name '*.jpg' \) | shuf -n 1)"

                if [ -n "$img" ]; then
                  swww img "$img" --transition-fps 240 --resize crop --transition-type grow
                fi

                sleep 60
              done
            '';
          in
          {
            exec-once = [
              "swww-daemon"
              "swww clear"
              "${random-wallpaper}"
            ];
          };
      };
  };
}
