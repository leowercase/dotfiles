{ inputs, pkgs, ... }:
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
      programs = {
        neovim.enable = true;
        git.enable = true;
        qutebrowser.enable = true;
        kitty.enable = true;
        btop.enable = true;
      };
    };

    hm.leo.home.packages = with pkgs; [
      tutanota-desktop
      discord
      prismlauncher
      krita
      lmms
      godot_4
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
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
