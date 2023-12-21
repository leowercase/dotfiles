{ inputs, ... }:
  {
    imports = with inputs.nixos-hardware.nixosModules;
      [ common-pc common-cpu-intel common-gpu-amd common-pc-ssd ];

    boot.initrd.availableKernelModules = [ "vmd" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
    boot.kernelModules = [ "kvm-intel" ];
    time.timeZone = "Europe/Helsinki";

    system' = {
      booting.enableSwap = true;
      networking = {
        enable = true;
        wifi = "iwd";
      };
      admin = "leo";
      zsaKeyboard.enable = true;
    };

    users'.leo = {
      enable = true;
      rices.hyprland.enable = true;
      suites = {
        dev.enable = true;
        basicApps.enable = true;
        gaming.enable = true;
        arts.enable = true;
      };
    };

    # I only have this on one machine, so it'll be fine...
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
    hm.leo.dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
    users.users.leo.extraGroups = [ "libvirtd" ];
  }
