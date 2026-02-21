{ inputs, ... }:
{
  flake.modules.nixos.desktop = {

    imports = [ inputs.hister.nixosModules.default ];
    services.hister = {
      enable = true;

      # Optional: Set via Nix options (takes precedence over config file)
      # port = 4433;
      dataDir = "/var/lib/hister"; # NixOS Recommend: "/var/lib/hister"
      # Home-Manager Recommend: "~/.local/share/hister"
      # Darwin Recommend: "~/Library/Application Support/hister"

      # Optional: Use existing YAML config file
      # configPath = /path/to/config.yml;

      # Optional: Inline configuration (converted to YAML)
      # Note: Only one of configPath or config can be used
      config = {
        app = {
          search_url = "https://kagi.com/search?q={query}";
          log_level = "info";
        };
        server = {
          address = "127.0.0.1:4433";
          database = "db.sqlite3";
        };
        hotkeys = {
          "/" = "focus_search_input";
          "enter" = "open_result";
          "alt+enter" = "open_result_in_new_tab";
          "alt+j" = "select_next_result";
          "alt+k" = "select_previous_result";
          "alt+o" = "open_query_in_search_engine";
        };
      };
    };
  };
}
