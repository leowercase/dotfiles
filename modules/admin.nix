{ config, lib, ... }:
  with lib;
  let
    cfg = config.custom.admin;
  in
  {
    options.custom.admin = mkOption {
      type = types.str;
      default = "root";
      description =
        "The adminstrator user of the system, who owns the configuration directory at `/etc/nixos`";
    };

    config.system.activationScripts.chown_config_to_admin.text = ''
      chown ${cfg}: /etc/nixos
    '';
  }
