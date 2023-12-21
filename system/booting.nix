{ config, lib, ... }:
  with lib;
  let
    cfg = config.system'.booting;
  in
  {
    # I usually do the same partitioning for all installations
    
    options.system'.booting = {
      enable = mkEnableOption "UEFI booting" // { default = true; };
      enableSwap = mkEnableOption "swap";
    };

    config = mkIf cfg.enable {
      # Disk
      fileSystems = {
        "/" = {
          device = "/dev/disk/by-label/nixos";
          fsType = "ext4";
        };
        "/boot" = {
          device = "/dev/disk/by-label/boot";
          fsType = "vfat";
        };
      };
      swapDevices = mkIf cfg.enableSwap [
        { device = "/dev/disk/by-label/swap"; }
      ];

      # Bootloader
      boot.loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = true;
          # It is recommended to disable editing the kernel
          # command-line before booting
          editor = false;
        };
      };
    };
  }
