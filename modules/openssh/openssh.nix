{
  flake.modules.nixos.openssh = {
    services.openssh = {
      enable = true;

      hostKeys = [
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];

      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "prohibit-password";
        PermitEmptyPasswords = false;
        MaxAuthTries = 3;
        MaxSessions = 2;

        KexAlgorithms = [
          "sntrup761x25519-sha512"
          "sntrup761x25519-sha512@openssh.com"
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
        ];

        Ciphers = [
          "chacha20-poly1305@openssh.com"
          "aes256-gcm@openssh.com"
        ];

        Macs = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
        ];

        # Hardening
        X11Forwarding = false;
        AcceptEnv = "";
        ClientAliveInterval = 300;
        ClientAliveCountMax = 2;
      };
    };

    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
