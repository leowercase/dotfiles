{ config, lib, ... }:
  with lib;
  let
    cfg = config.custom.admin;
  in
  {
    options.custom.admin = mkOption {
      type = types.str;
      default = "root";
      description = "The system adminstrator user, who owns the configuration directory.";
    };

    config = {
      assertions = [
        {
          assertion = config.users.users ? cfg;
          message = "the set admin user does not exist";
        }
      ];

      system.activationScripts.chown-config-to-admin.text = ''
        chown ${cfg} /etc/nixos
      '';
    };
  }
