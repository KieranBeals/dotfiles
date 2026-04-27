let
  discordNoVpnUid = 615;
  discordNoVpnRulePref = 30896;
in
{
  flake.modules = {
    nixos.messaging =
      { pkgs, lib, ... }:
      let
        discordExe = lib.getExe pkgs.discord;
        discordUidRange = "${toString discordNoVpnUid}-${toString discordNoVpnUid}";
        installDiscordNoVpnRules = pkgs.writeShellScript "install-discord-novpn-rules" ''
          set -euo pipefail

          log_info() {
            printf '%s\n' "$*" | ${pkgs.systemd}/bin/systemd-cat --identifier=discord-novpn-routing -p info
          }

          log_error() {
            printf '%s\n' "$*" | ${pkgs.systemd}/bin/systemd-cat --identifier=discord-novpn-routing -p err
          }

          route_family() {
            local family="$1"
            local rule_selector=(uidrange ${discordUidRange} lookup main)

            if ! ${pkgs.iproute2}/bin/ip -"''${family}" rule list >/dev/null 2>&1; then
              log_info "IPv''${family}: skipping routing update (address family unavailable)"
              return 0
            fi

            while ${pkgs.iproute2}/bin/ip -"''${family}" rule del pref ${toString discordNoVpnRulePref} 2>/dev/null; do
              :
            done
            log_info "IPv''${family}: deleted stale Discord policy routing rules at pref ${toString discordNoVpnRulePref}"

            while ${pkgs.iproute2}/bin/ip -"''${family}" rule del pref 30897 "''${rule_selector[@]}" 2>/dev/null; do
              :
            done
            while ${pkgs.iproute2}/bin/ip -"''${family}" rule del pref 30897 uidrange ${discordUidRange} unreachable 2>/dev/null; do
              :
            done
            log_info "IPv''${family}: deleted legacy Discord policy routing rules at pref 30897"

            if ${pkgs.iproute2}/bin/ip -"''${family}" rule add pref ${toString discordNoVpnRulePref} "''${rule_selector[@]}"; then
              log_info "IPv''${family}: installed Discord policy routing rule"
            else
              log_error "IPv''${family}: failed to install Discord policy routing rule"
              return 1
            fi
          }

          route_family 4 || true
          route_family 6 || true

          log_info "discord-novpn routing rules refreshed"
        '';
      in
      {
        users.groups.discord-novpn.gid = discordNoVpnUid;
        users.users.discord-novpn = {
          isSystemUser = true;
          uid = discordNoVpnUid;
          group = "discord-novpn";
          extraGroups = [
            "audio"
            "render"
            "video"
          ];
          home = "/var/lib/discord-novpn";
          createHome = true;
        };

        services.resolved.enable = true;
        networking.networkmanager.dns = "systemd-resolved";

        systemd.services.discord-novpn-routing = {
          description = "Install policy routing rules for Discord outside Proton VPN";
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = installDiscordNoVpnRules;
          };
        };

        networking.networkmanager.dispatcherScripts = [
          {
            source = pkgs.writeShellScript "discord-novpn-dispatcher" ''
              case "$2" in
                up|down|pre-up|pre-down|vpn-up|vpn-down|ip-change|ip4-change|ip6-change|dhcp4-change|dhcp6-change|connectivity-change|connectivity-timeout)
                  ${installDiscordNoVpnRules}
                  ;;
              esac
            '';
            type = "basic";
          }
        ];

        security.sudo.extraRules = [
          {
            users = [ "kieran" ];
            commands = [
              {
                command = discordExe;
                options = [
                  "NOPASSWD"
                  "SETENV"
                ];
              }
            ];
            runAs = "discord-novpn";
          }
        ];
      };

    homeManager.messaging =
      { pkgs, lib, ... }:
      let
        discordExe = lib.getExe pkgs.discord;
        discordLauncherBody = ''
          set -euo pipefail

          log_file="/tmp/discord-launch.log"
          : > "$log_file"
          exec >>"$log_file" 2>&1

          echo "[discord-launcher] argv=$*"

          if [ "''${DISCORD_LEGACY_X11:-0}" = "1" ]; then
            export XDG_SESSION_TYPE=x11
            unset NIXOS_OZONE_WL
          elif [ -n "''${WAYLAND_DISPLAY:-}" ]; then
            export NIXOS_OZONE_WL=1
            export XDG_SESSION_TYPE=wayland
          else
            export XDG_SESSION_TYPE=x11
            unset NIXOS_OZONE_WL
          fi

          discord_args=("$@")
          if [ "''${DISCORD_FALLBACK_DISABLE_GPU:-0}" = "1" ]; then
            discord_args+=(--disable-gpu)
          fi
        '';
        discordStableRun = ''
          ${discordLauncherBody}
          exec ${discordExe} "''${discord_args[@]}"
        '';
        discordNoVpnRun = ''
          ${discordLauncherBody}

          export XDG_SESSION_TYPE=x11
          unset NIXOS_OZONE_WL
          unset WAYLAND_DISPLAY

          grant_acl() {
            local path="$1"
            local perms="$2"

            if [ -e "$path" ]; then
              setfacl -m "u:${toString discordNoVpnUid}:$perms,m::$perms" "$path" 2>/dev/null || true
            fi
          }

          grant_acl "''${XDG_RUNTIME_DIR:-}" x
          grant_acl "''${XDG_RUNTIME_DIR:-}/pulse" x
          grant_acl "''${XDG_RUNTIME_DIR:-}/pulse/native" rw

          export XAUTHORITY="''${XAUTHORITY:-$HOME/.Xauthority}"
          grant_acl "$XAUTHORITY" r

          if [ -n "''${DISPLAY:-}" ]; then
            xhost +SI:localuser:discord-novpn >/dev/null 2>&1 || true
          fi

          if [ -z "''${PULSE_SERVER:-}" ] && [ -n "''${XDG_RUNTIME_DIR:-}" ]; then
            export PULSE_SERVER="unix:''${XDG_RUNTIME_DIR}/pulse/native"
          fi

          exec /run/wrappers/bin/sudo \
            --user=discord-novpn \
            --preserve-env=DISPLAY,PULSE_SERVER,XDG_SESSION_TYPE,XAUTHORITY \
            HOME=/var/lib/discord-novpn \
            XDG_CONFIG_HOME=/var/lib/discord-novpn/.config \
            XDG_CACHE_HOME=/var/lib/discord-novpn/.cache \
            ${discordExe} \
            --user-data-dir=/var/lib/discord-novpn/.config/discord \
            "''${discord_args[@]}"
        '';
        discordWrapper = pkgs.writeShellApplication {
          name = "discord";
          runtimeInputs = with pkgs; [
            coreutils
          ];
          text = discordStableRun;
        };
        discordNoVpnWrapper = pkgs.writeShellApplication {
          name = "discord-novpn";
          runtimeInputs = with pkgs; [
            acl
            coreutils
            xhost
          ];
          text = discordNoVpnRun;
        };
        discordDesktop = pkgs.makeDesktopItem {
          name = "discord";
          desktopName = "Discord";
          exec = "discord %U";
          icon = "discord";
          startupWMClass = "discord";
          mimeTypes = [ "x-scheme-handler/discord" ];
          categories = [
            "Network"
            "InstantMessaging"
          ];
        };
        discordPackage = pkgs.symlinkJoin {
          name = "discord";
          paths = [
            discordWrapper
            discordNoVpnWrapper
            discordDesktop
          ];
          postBuild = ''
            mkdir -p $out/share/icons/hicolor/256x256/apps
            ln -s ${pkgs.discord}/opt/Discord/discord.png $out/share/icons/hicolor/256x256/apps/discord.png
          '';
        };
      in
      {
        home.packages = [
          discordPackage
        ];
      };
  };
}
