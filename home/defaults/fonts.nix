{ config, lib, ... }:
  with lib;
  let
    cfg = config.custom.defaults.fonts;

    defaultFonts = {
      serif = "serif";
      sansSerif = "sans-serif";
      monospace = "monospace";
      emoji = "emoji";
    };
  in
  {
    options.custom.defaults.fonts =
      mapAttrs
        (name: desc: mkOption {
          type = with types; either (listOf str) str;
          default = [];
          description = "The default ${desc} font(s) to use.";
        })
        defaultFonts;

    config =
      mkIf (any (f: f != []) (attrValues cfg)) {
        fonts.fontconfig.enable = true;

        xdg.configFile."fontconfig/fonts.conf".text =
          let
            definitions = with builtins;
              concatStringsSep "\n" (attrValues (mapAttrs
                (name: f:
                  let fonts = toList f;
                  in if fonts == [] then ""
                    else ''
                      <alias binding="same">
                        <family>${defaultFonts.${name}}</family>
                        <prefer>
                          ${concatStringsSep ""
                            (map (font: "<family>${font}</family>\n") fonts)}
                        </prefer>
                      </alias>
                    '')
                cfg));
          in
          ''
            <?xml version="1.0"?>
            <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
            <fontconfig>
              <!-- Default fonts -->
              ${definitions}
            </fontconfig>
          '';
      };
  }