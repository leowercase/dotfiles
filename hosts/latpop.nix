{ inputs, pkgs, ... }:
  {
    imports = with inputs.nixos-hardware.nixosModules;
      [ common-pc-laptop common-pc-laptop-acpi_call common-cpu-intel common-pc-laptop-ssd ];

    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" ];
    boot.kernelModules = [ "kvm-intel" ];
    time.timeZone = "Europe/Helsinki";

    system' = {
      booting.enableSwap = true;
      networking = {
        enable = true;
        wifi = "iwd";
      };
      admin = "leo";
    };
     
    users'.leo = {
      enable = true;
      desktop.hyprland.enable = true;
      programs = {
        neovim.enable = true;
        git.enable = true;
        qutebrowser.enable = true;
        firefox.enable = true;
        kitty.enable = true;
        btop.enable = true;
      };
    };

    home-manager.users.leo.home.packages = with pkgs; [
      godot_4
    ];
  }
