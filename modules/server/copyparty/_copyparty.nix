{ inputs, ... }:
{
  flake.modules.nixos.copyparty =
    { pkgs, ... }:
    {
      nixpkgs.overlays = [ inputs.copyparty.overlays.default ];
      environment.systemPackages = [ pkgs.copyparty ];

      security.acme = {
        acceptTerms = true;
        defaults.email = "contact@kieranbeals.com";
        certs."kieranbeals.com" = {
          extraDomainNames = [ "*.kieranbeals.com" ];
          dnsProvider = "cloudflare";
          credentialsFile = "/run/keys/acme-dns-credentials";
          group = "nginx";
        };
      };

      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;

        virtualHosts."files.kieranbeals.com" = {
          useACMEHost = "kieranbeals.com";
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:3210";
            proxyWebsockets = true;
            extraConfig = ''
              client_max_body_size 0;
              proxy_buffering off;
              proxy_request_buffering off;
            '';
          };
        };
      };

      services.copyparty = {
        enable = true;
        user = "copyparty";
        group = "copyparty";
        settings = {
          i = "127.0.0.1";
          p = [ 3210 ];
          no-reload = true;
          ignored-flag = false;
          http-only = true;
        };
        accounts = {
          k.passwordFile = "/run/keys/copyparty/k_password";
          a.passwordFile = "/run/keys/copyparty/a_password";
        };
        groups = {
          g1 = [
            "k"
            "a"
          ];
        };
        volumes = {
          "/" = {
            path = "/srv/copyparty";
            access = {
              r = [ "a" ];
              A = [ "k" ];
            };
            flags = {
              fk = 4;
              scan = 60;
              e2d = true;
              d2t = true;
              nohash = "\.iso$";
            };
          };
        };
        openFilesLimit = 8192;
      };
    };
}
