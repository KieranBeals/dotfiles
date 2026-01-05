{ inputs, ... }:
{
  flake.modules = {
    homeManager.desktop = {
      imports = [
        inputs.plasma-manager.homeManagerModules.plasma-manager
      ];

      programs.plasma = {
        configFile = {
          kcminputrc."Libinput/2362/628/PIXA3854:00 093A:0274 Touchpad".NaturalScroll = true;
        };
      };
    };
  };
}
