{
  flake.modules = {
    nixos.hyprland =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          awww
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
                  awww img "$img" --transition-fps 240 --resize crop --transition-type grow
                fi

                sleep 60
              done
            '';
          in
          {
            exec-once = [
              "awww-daemon"
              "awww clear"
              "${random-wallpaper}"
            ];
          };
      };
  };
}
