# until https://github.com/andreashgk/hytale-nix supports semi auto updating,
# I have to commit the sin of flatpak
{
  flake.modules = {
    nixos.desktop = {
      services.flatpak.enable = true;
    };
  };
}
