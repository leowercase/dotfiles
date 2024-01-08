{ lib, config, pkgs, ... }:
  with lib;
  let
    cfg = config.users'.leo.programs.swayidle;
  in
  {
    options.users'.leo.programs.swayidle = {
      enable = mkEnableOption "swayidle";
      suspendTimeout = mkOption {
        type = types.ints.positive;
        default = 300; # 5 minutes
        description = "The amount of idle time before the screen locks and the machine suspends.";
      };
      screenLocker = mkOption {
        type = types.str;
        description = "The screen locker to use.";
      };
    };

    config.home-manager.users.leo.services.swayidle = mkIf cfg.enable {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.systemd}/bin/loginctl lock-session";
        }
        { event = "lock"; command = cfg.screenLocker; }
      ];
      timeouts =
        let
          suspendScript = pkgs.writeShellScript "suspend_script.sh" ''
            ${pkgs.pipewire}/bin/pw-cli info all | ${pkgs.ripgrep}/bin/rg running
            if [ $? == 1 ]; then
              ${pkgs.systemd}/bin/systemctl suspend
            fi
          '';
        in singleton { timeout = cfg.suspendTimeout; command = suspendScript.outPath; };
    };
  }
