{ config, lib, ... }:
  with lib;
  let
    cfg = config.custom.mimeDefaults;
  in
  {
    options.custom.mimeDefaults =
      mapAttrs
        (_: desc: mkOption {
          type = with types; coercedTo (either (listOf str) str) toList (listOf str);
          default = [];
          description = "The XDG MIME desktop entry for ${desc}.";
        })
        {
          text = "editing text";
          urls = "opening URLs";
	};

    config = {
      xdg = {
        mime.enable = true;
        mimeApps = {
          enable = true;
          defaultApplications =
            foldl' mergeAttrs {}
              (attrValues (mapAttrs
                (name: mimeTypes: genAttrs mimeTypes (_: cfg.${name}))
                {
        	  text = [ "text/plain" ];
                  urls = [
                    "x-scheme-handler/http"
                    "x-scheme-handler/https"
                    "x-scheme-handler/about"
                    "x-scheme-handler/unknown"
                  ];
                }));
        };
      };
    };
}
