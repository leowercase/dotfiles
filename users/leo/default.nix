{ lib, customLib, config, ... }:
  with lib;
  {
    imports = customLib.getModules'' ./.;

    options.users'.leo.enable = mkEnableOption "Leo";

    config = mkIf config.users'.leo.enable {
      users.users.leo = {
        description = "Leo";
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };

      users'.leo = {
        programs.default = {
          shell = "bash";
          editor = "nvim";
          pager = "nvimpager -p";
          browser = "qutebrowser";
          terminal = "kitty";
        };

        xdg.enable = true;
        xdg.defaultApps = {
          text = "nvim.desktop";
          urls = "org.qutebrowser.qutebrowser.desktop";
        };
      };
    };
  }
