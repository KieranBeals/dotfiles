{ config, ... }:
{
  flake = {
    meta.users.kieran = {
      name = "Kieran Beals";
      email = "kieranbeals@gmail.com";
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJYE+NOzj9PuzT56bxgxeAlCNMYOVzO12fCEmo8N+7oY kieran@laptop"
      ];
    };

    # kieran's portable home profile: the home-manager modules that follow the
    # user onto any host (Linux or macOS), regardless of which machine they sit
    # on. Host-/hardware-specific home bits (nvidia, amd, the WM, …) stay on the
    # host via `homeModules`. Grow this as you make more modules OS-agnostic.
    modules.homeManager."users/kieran" = {
      imports = with config.flake.modules.homeManager; [
        homeManager # base home (username, stateVersion, home-manager itself)
      ];
    };
  };
}
