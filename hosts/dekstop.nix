{ flake, ... }:
   {
     imports = with flake.nixos-hardware.nixosModules;
       [ common-pc common-cpu-intel common-gpu-amd common-pc-ssd ];

     boot.initrd.availableKernelModules = [ "vmd" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
     boot.kernelModules = [ "kvm-intel" ];
     custom = {
       booting.enableSwap = true;
       networking = {
         enable = true;
         wifi = "iwd";
       };
       audio = "pipewire";
       admin = "leo";
     };
     hardware.keyboard.zsa.enable = true;
     users.users.leo = {
       isNormalUser = true;
       description = "Leo";
       extraGroups = [ "wheel" ];
     };
     time.timeZone = "Europe/Helsinki";
     programs.hyprland.enable = true;
     programs.steam = {
       enable = true;
       remotePlay.openFirewall = true;
       dedicatedServer.openFirewall = true;
     };
  }
