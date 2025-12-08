{
  flake.modules.nixos.desktop =
  { pkgs, ... }:
  {
    environment.systemPackages = with pkgs; [
      kdePackages.dolphin

      # Icons
      kdePackages.qtsvg

      # For network shares
      kdePackages.kio
      kdePackages.kio-fuse # to mount remote filesystems via FUSE
      kdePackages.kio-extras # extra protocols support (sftp, fish and more)
    ];
  };
}
