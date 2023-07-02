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
     users.users.leo = {
       isNormalUser = true;
       description = "Leo";
       extraGroups = [ "wheel" ];
     };
     programs.hyprland.enable = true;
     programs.steam = {
       enable = true;
       remotePlay.openFirewall = true;
       dedicatedServer.openFirewall = true;
       gamescopeSession = {
         enable = true;
	 env = { SDL_VIDEODRIVER = "x11"; }; # Games prefer X11
	 args = [ "-W 2560" "-H 1440" "-e" ];
       };
     };
  }
