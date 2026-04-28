{
  flake.modules = {
    nixos.waybar =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      let
        weatherNoVpnUid = 616;
        weatherNoVpnRulePref = 30895;
        weatherUidRange = "${toString weatherNoVpnUid}-${toString weatherNoVpnUid}";
        staleNobodyUidRange = "65534-65534";
        installWeatherNoVpnRules = pkgs.writeShellScript "install-weather-novpn-rules" ''
          set -euo pipefail

          log_info() {
            printf '%s\n' "$*" | ${pkgs.systemd}/bin/systemd-cat --identifier=weather-novpn-routing -p info
          }

          log_error() {
            printf '%s\n' "$*" | ${pkgs.systemd}/bin/systemd-cat --identifier=weather-novpn-routing -p err
          }

          route_family() {
            local family="$1"
            local weather_rule=(uidrange ${weatherUidRange} lookup main)

            if ! ${pkgs.iproute2}/bin/ip -"''${family}" rule list >/dev/null 2>&1; then
              log_info "IPv''${family}: skipping routing update (address family unavailable)"
              return 0
            fi

            while ${pkgs.iproute2}/bin/ip -"''${family}" rule del pref ${toString weatherNoVpnRulePref} 2>/dev/null; do
              :
            done
            log_info "IPv''${family}: deleted stale weather policy routing rules at pref ${toString weatherNoVpnRulePref}"

            while ${pkgs.iproute2}/bin/ip -"''${family}" rule del pref ${toString weatherNoVpnRulePref} uidrange ${staleNobodyUidRange} lookup main 2>/dev/null; do
              :
            done
            while ${pkgs.iproute2}/bin/ip -"''${family}" rule del pref 30896 uidrange ${staleNobodyUidRange} lookup main 2>/dev/null; do
              :
            done
            log_info "IPv''${family}: deleted stale nobody policy routing rules"

            if ${pkgs.iproute2}/bin/ip -"''${family}" rule add pref ${toString weatherNoVpnRulePref} "''${weather_rule[@]}"; then
              log_info "IPv''${family}: installed weather policy routing rule"
            else
              log_error "IPv''${family}: failed to install weather policy routing rule"
              return 1
            fi
          }

          route_family 4 || true
          route_family 6 || true

          log_info "weather-novpn routing rules refreshed"
        '';
        vpnEnabled = config.dotfiles.vpn.enable or false;
      in
      {
        environment.systemPackages = with pkgs; [
          waybar
          blueman
          jq
          pavucontrol
        ];

        users.groups.weather-novpn = lib.mkIf vpnEnabled {
          gid = weatherNoVpnUid;
        };

        users.users.weather-novpn = lib.mkIf vpnEnabled {
          isSystemUser = true;
          uid = weatherNoVpnUid;
          group = "weather-novpn";
          home = "/var/empty";
          createHome = false;
        };

        systemd.services.weather-novpn-routing = lib.mkIf vpnEnabled {
          description = "Install policy routing rules for Waybar weather outside Proton VPN";
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = installWeatherNoVpnRules;
          };
        };

        security.sudo.extraRules = lib.mkIf vpnEnabled [
          {
            users = [ "kieran" ];
            commands = [
              {
                command = "/run/current-system/sw/bin/curl";
                options = [
                  "NOPASSWD"
                  "NOSETENV"
                ];
              }
            ];
            runAs = "weather-novpn";
          }
        ];
      };
    homeManager.waybar = {
      home.file.".config/waybar" = {
        source = ./config;
        recursive = true;
      };

      # Autostart if on hyprland
      wayland.windowManager.hyprland.settings.exec-once = [
        "waybar"
      ];
    };
  };
}
