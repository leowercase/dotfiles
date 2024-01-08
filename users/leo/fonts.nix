{ config, lib, customLib, pkgs, ... }:
  with lib;
  let
    cfg = config.users'.leo.fonts;
  in
  {
    options.users'.leo.fonts = {
      enable = mkEnableOption "font configuration" // { default = true; };
      aliases = mkOption {
        type = with types; attrsOf (customLib.types.listOfOrSingleton str);
        default = {};
        description = "Alias the specified fonts with other fonts.";
      };
      useCoreFontCompatible = mkEnableOption "open source replacements for Microsoft core fonts";
    };

    config = mkMerge [
      (mkIf cfg.enable {
        home-manager.users.leo = {
          fonts.fontconfig.enable = true;

          xdg.configFile."fontconfig/fonts.conf".text =
            let
              mkFamily = name: "<family>${name}</family>";

              mkAlias = family: aliases: ''
                <alias binding="same">
                ${mkFamily family}
                <prefer>${concatStrings (map mkFamily aliases)}</prefer>
                </alias>
              '';

              aliases = concatStringsSep "\n" (attrValues (mapAttrs mkAlias cfg.aliases));
            in
            ''
              <?xml version="1.0"?>
              <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
              <fontconfig>
              ${aliases}
              </fontconfig>
            '';
        };
      })

      # See
      # * https://en.wikipedia.org/wiki/Core_fonts_for_the_Web
      # * https://wiki.archlinux.org/title/Metric-compatible_fonts
      (mkIf cfg.useCoreFontCompatible {
        users'.leo.fonts.aliases = {
          "Arial" = "Liberation Sans";
          "Times New Roman" = "Liberation Serif";
          "Courier New" = "Liberation Mono";
          "Comic Sans MS" = "Comic Relief";
          "Georgia" = "Gelasio";
        };

        home-manager.users.leo.home.packages = with pkgs; [
          liberation_ttf
          comic-relief
          gelasio
        ];
      })
    ];
  }
