{
  flake.modules.nixos.laptop = {
    services.tlp = {
      enable = true;
      # Settings taken from: https://linrunner.de/tlp/support/optimizing.html#extend-battery-runtime
      settings = {
        CPU_ENERGY_PERF_POLICY_ON_BAT="power";
        PLATFORM_PROFILE_ON_BAT="low-power";
        CPU_BOOST_ON_BAT="0";
        CPU_BOOST_ON_SAV="0";
        CPU_HWP_DYN_BOOST_ON_BAT="0";
        CPU_HWP_DYN_BOOST_ON_SAV="0";
        AMDGPU_ABM_LEVEL_ON_BAT="3";
      };
    };
	};
}
