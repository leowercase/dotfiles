{ inputs, config, lib, pkgs, ... }:
  with lib;
  let
    cfg = config.users'.leo.programs.firefox;

    inherit (config.nur.repos.rycee) firefox-addons;
  in
  {
    options.users'.leo.programs.firefox = {
      enable = mkEnableOption "my Firefox";
    };

    config.home-manager.users.leo = mkIf cfg.enable {
      imports = [ inputs.arkenfox-nixos.hmModules.arkenfox ];

      programs.firefox = {
        enable = true;
        arkenfox = {
          enable = true;
          version = "122.0";
        };

        profiles.default = {
          isDefault = true;

          settings = {
            "browser.shell.checkDefaultBrowser" = false;
            "browser.aboutConfig.showWarning" = false;

            # Allows using addons on addons.mozilla.org
            "extensions.webextensions.restrictedDomains" = "";
            "privacy.resistFingerprinting.block_mozAddonManager" = true;

            # Doesn't disable any extensions after first install
            "extensions.autoDisableScopes" = 0;
          };

          extensions = with firefox-addons; [
            ublock-origin
            darkreader
            tridactyl
          ];

          search = {
            force = true;
            default = "Brave";
            engines = {
              "Brave" = {
                urls = [ { template = "https://search.brave.com/search?q={searchTerms}"; } ];
              };
            };
          };

          arkenfox = {
            enable = true;
            "0100" = {
              enable = true;
              "0102"."browser.startup.page".value = 1;
            };
            "0200".enable = true;
            "0300".enable = true;
            "0400".enable = true;
            "0600".enable = true;
            "0700".enable = true;
            "0800".enable = true;
            "0900".enable = true;
            "1000" = {
              enable = true;
              "1001"."browser.cache.disk.enable".enable = true;
              "1001"."browser.cache.disk.enable".value = true;
            };
            "1200".enable = true;
            "2400".enable = true;
            "2600".enable = true;
            "2700".enable = true;
            "2800".enable = true;
            "4000".enable = true;
            "9000".enable = true;
          };
        };

        nativeMessagingHosts = [ pkgs.tridactyl-native ];
      };

      xdg.configFile."tridactyl/tridactylrc".text = ''
        bind J tabnext
        bind K tabprev
      '';
    };
  }
