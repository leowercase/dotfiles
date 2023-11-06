{ lib, pkgs, config, ... }:
  with lib;
  let
    cfg = config.users'.leo.xdg;
  in
  {
    options.users'.leo.xdg = {
      enable = mkEnableOption "XDG";
      lowercaseUserDirs = mkEnableOption "lowercase XDG user dirs" // { default = true; };
      defaultApps = 
        mapAttrs
          (_: desc: mkOption {
            type = custom.types.listOfOrSingleton types.str;
            default = [];
            description = "The XDG MIME desktop entry for ${desc}.";
          })
          {
            text = "editing text";
            urls = "opening URLs";
          };
    };

    config.hm.leo = mkIf cfg.enable (args:
      let hmConfig = args.config;
      in {
        xdg = {
          enable = true;
          mime.enable = true;
        };
        home.packages = [ pkgs.xdg-utils ];

        xdg.userDirs = mkMerge [
          {
            enable = true;
            createDirectories = true;
          }
          (mkIf cfg.lowercaseUserDirs
            (mapAttrs
              (_: dir: "${hmConfig.home.homeDirectory}/${dir}")
              {
                desktop = "desktop";
                documents = "documents";
                download = "downloads";
                music = "music";
                pictures = "pictures";
                publicShare = "public";
                templates = "templates";
                videos = "videos";
              }))
        ];
        
        xdg.mimeApps = {
          enable = true;
          defaultApplications =
            attrsets.mergeAttrsList
              (attrValues (mapAttrs
                (name: mimeTypes: genAttrs (_: cfg.defaultApps.${name}))
                {
        	  text = singleton "text/plain";
                  urls = [
                    "x-scheme-handler/http"
                    "x-scheme-handler/https"
                    "x-scheme-handler/about"
                    "x-scheme-handler/unknown"
                  ];
                }));
        };
    });
  }
