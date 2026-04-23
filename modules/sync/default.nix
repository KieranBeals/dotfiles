{ ... }:
  {
  flake.modules.nixos.sync =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.services.protonDriveBisync;
      sopsSshKeys = builtins.filter builtins.pathExists [
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_rsa_key"
        "/home/kieran/.ssh/id_ed25519"
        "/home/kieran/.ssh/id_rsa"
        "/home/kieran/.config/sops/age/keys.txt"
      ];
      hasSopsKeySource = sopsSshKeys != [ ];

      stateDir = "/var/lib/proton-drive-bisync";
      cacheDir = "${stateDir}/cache";
      bisyncDir = "${stateDir}/bisync";
      testFile = "${cfg.localPath}/RCLONE_TEST";
      remoteSpec = "${cfg.remoteName}:${cfg.remotePath}";
      rcloneConfigTemplate = config.sops.templates."rclone-proton-drive.conf";

      commonBisyncArgs = [
        "bisync"
        cfg.localPath
        remoteSpec
        "--config=${rcloneConfigTemplate.path}"
        "--workdir=${bisyncDir}"
        "--compare=size,checksum"
        "--check-access"
        "--check-filename=RCLONE_TEST"
        "--conflict-resolve=newer"
        "--conflict-loser=num"
        "--max-delete=${cfg.maxDelete}"
        "--resilient"
        "--recover"
        "--retries=3"
        "--retries-sleep=30s"
        "--max-lock=${cfg.maxLock}"
        "--create-empty-src-dirs"
        "--protondrive-replace-existing-draft=true"
        "--log-format=date,time"
      ];

      mkBisyncScript =
        name: extraArgs:
        pkgs.writeShellScript name ''
          set -euo pipefail

          exec ${pkgs.rclone}/bin/rclone ${lib.escapeShellArgs (commonBisyncArgs ++ extraArgs)}
        '';

      bootstrapScript = pkgs.writeShellScript "proton-drive-bisync-bootstrap" ''
        set -euo pipefail

        ${pkgs.coreutils}/bin/mkdir -p ${lib.escapeShellArg cfg.localPath}
        ${pkgs.coreutils}/bin/touch ${lib.escapeShellArg testFile}

        if ! ${pkgs.rclone}/bin/rclone lsf \
          --config=${lib.escapeShellArg rcloneConfigTemplate.path} \
          ${lib.escapeShellArg remoteSpec} | ${pkgs.gnugrep}/bin/grep -Fxq RCLONE_TEST; then
          exec ${pkgs.rclone}/bin/rclone copyto \
            ${lib.escapeShellArg testFile} \
            ${lib.escapeShellArg "${remoteSpec}/RCLONE_TEST"} \
            --config=${lib.escapeShellArg rcloneConfigTemplate.path} \
            --protondrive-replace-existing-draft=true \
            --log-format=date,time
        fi
      '';
    in
    {
      options.services.protonDriveBisync = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable Proton Drive bidirectional sync via rclone bisync.";
        };
        user = lib.mkOption {
          type = lib.types.str;
          default = "kieran";
        };
        group = lib.mkOption {
          type = lib.types.str;
          default = "users";
        };
        localPath = lib.mkOption {
          type = lib.types.str;
          default = "/home/kieran/Documents/ProtonDrive";
        };
        remoteName = lib.mkOption {
          type = lib.types.str;
          default = "proton";
        };
        remotePath = lib.mkOption {
          type = lib.types.str;
          default = "Computers/shared";
        };
        interval = lib.mkOption {
          type = lib.types.str;
          default = "5min";
        };
        maxLock = lib.mkOption {
          type = lib.types.str;
          default = "2h";
        };
        maxDelete = lib.mkOption {
          type = lib.types.str;
          default = "20%";
        };
        requireVpn = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
      };

      config = lib.mkIf (cfg.enable && hasSopsKeySource) {
        environment.systemPackages = with pkgs; [
          age
          rclone
          sops
          ssh-to-age
        ];

        sops = {
          defaultSopsFile = ../../secrets/proton-drive.yaml;
          defaultSopsFormat = "yaml";

          age.sshKeyPaths = sopsSshKeys;

          secrets = {
            proton_username = { };
            proton_password = { };
            proton_mailbox_password = { };
            proton_otp_secret_key = { };
            proton_2fa = { };
          };

          templates."rclone-proton-drive.conf" = {
            path = "/run/secrets/rclone-proton-drive.conf";
            owner = cfg.user;
            group = cfg.group;
            mode = "0400";
            content = ''
              [${cfg.remoteName}]
              type = protondrive
              username = ${config.sops.placeholder.proton_username}
              password = ${config.sops.placeholder.proton_password}
              mailbox_password = ${config.sops.placeholder.proton_mailbox_password}
              # Use OTP secret for non-interactive auth; leave 2fa empty unless needed.
              otp_secret_key = ${config.sops.placeholder.proton_otp_secret_key}
              2fa = ${config.sops.placeholder.proton_2fa}
            '';
          };
        };

        systemd.tmpfiles.rules = [
          "d ${cfg.localPath} 0750 ${cfg.user} ${cfg.group} - -"
          "d ${bisyncDir} 0750 ${cfg.user} ${cfg.group} - -"
          "d ${cacheDir} 0750 ${cfg.user} ${cfg.group} - -"
        ];

        systemd.services = {
          proton-drive-bisync = {
            description = "Proton Drive bidirectional sync";
            after = [ "network-online.target" ];
            wants = [ "network-online.target" ];
            environment = {
              RCLONE_CACHE_DIR = cacheDir;
              RCLONE_CONFIG = rcloneConfigTemplate.path;
            };
            serviceConfig = {
              Type = "oneshot";
              User = cfg.user;
              Group = cfg.group;
              StateDirectory = "proton-drive-bisync";
              UMask = "0077";
              WorkingDirectory = cfg.localPath;
              ExecStartPre = [
                "${pkgs.coreutils}/bin/mkdir -p ${cfg.localPath}"
                "${pkgs.coreutils}/bin/mkdir -p ${bisyncDir}"
                "${pkgs.coreutils}/bin/mkdir -p ${cacheDir}"
              ];
              ExecStart = mkBisyncScript "proton-drive-bisync" [ ];
            };
          };

          proton-drive-bisync-bootstrap = {
            description = "Bootstrap Proton Drive bisync access marker";
            after = [ "network-online.target" ];
            wants = [ "network-online.target" ];
            environment = {
              RCLONE_CACHE_DIR = cacheDir;
              RCLONE_CONFIG = rcloneConfigTemplate.path;
            };
            serviceConfig = {
              Type = "oneshot";
              User = cfg.user;
              Group = cfg.group;
              StateDirectory = "proton-drive-bisync";
              UMask = "0077";
              WorkingDirectory = cfg.localPath;
              ExecStartPre = [
                "${pkgs.coreutils}/bin/mkdir -p ${cfg.localPath}"
                "${pkgs.coreutils}/bin/mkdir -p ${bisyncDir}"
                "${pkgs.coreutils}/bin/mkdir -p ${cacheDir}"
              ];
              ExecStart = bootstrapScript;
            };
          };

          proton-drive-bisync-resync = {
            description = "Resync Proton Drive bisync state";
            after = [ "network-online.target" ];
            wants = [ "network-online.target" ];
            environment = {
              RCLONE_CACHE_DIR = cacheDir;
              RCLONE_CONFIG = rcloneConfigTemplate.path;
            };
            serviceConfig = {
              Type = "oneshot";
              User = cfg.user;
              Group = cfg.group;
              StateDirectory = "proton-drive-bisync";
              UMask = "0077";
              WorkingDirectory = cfg.localPath;
              ExecStartPre = [
                "${pkgs.coreutils}/bin/mkdir -p ${cfg.localPath}"
                "${pkgs.coreutils}/bin/mkdir -p ${bisyncDir}"
                "${pkgs.coreutils}/bin/mkdir -p ${cacheDir}"
              ];
              ExecStart = mkBisyncScript "proton-drive-bisync-resync" [ "--resync" ];
            };
          };
        };

        systemd.timers.proton-drive-bisync = {
          description = "Run Proton Drive bisync periodically";
          timerConfig = {
            OnBootSec = "10min";
            OnUnitActiveSec = cfg.interval;
            RandomizedDelaySec = "30s";
            Persistent = true;
          };
          unitConfig = {
            Requires = [ "proton-drive-bisync.service" ];
          };
        };
      };
    };
}
