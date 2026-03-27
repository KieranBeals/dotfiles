{
  flake.modules.homeManager.apk =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.writeShellScriptBin "waydroid-setup" ''
          echo "Installing all apks at ~/apps/android"
          sudo ${pkgs.waydroid}/bin/waydroid init

          APK_DIR="$HOME/apps/android"

          mkdir -p "$APK_DIR"

          cd $APK_DIR

          echo "$APK_DIR"

          ${pkgs.waydroid}/bin/waydroid session start & disown

          for apk in "$APK_DIR"/*.apk; do
            [ -f "$apk" ] || continue
            echo "Installing: $(basename "$apk")"
            ${pkgs.waydroid}/bin/waydroid app install "$apk" > /dev/null
            echo "Installed"
          done

          echo "All waydroid apks installed"
        '')
      ];
    };
}
