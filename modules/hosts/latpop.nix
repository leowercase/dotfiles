{ flake, ... }:
   {
    imports = with flake.nixos-hardware.nixosModules;
      [ common-pc-laptop common-pc-laptop-acpi_call common-cpu-intel common-gpu-amd common-pc-laptop-ssd ];

    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" ];
    boot.kernelModules = [ "kvm-intel" ];
    custom = {
      booting.enableSwap = true;
      networking = {
        enable = true;
        wifi = "iwd";
      };
      audio = "pipewire";
      graphical = true;
    };
    users.users.leo = {
      isNormalUser = true;
      description = "Leo";
      extraGroups = [ "wheel" ];
    };
    custom.admin = "leo";
  }
