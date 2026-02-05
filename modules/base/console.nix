{
  flake.modules.nixos.nixos = {
    services.xserver.xkb = {
      layout = "us";
    };
  };
}
