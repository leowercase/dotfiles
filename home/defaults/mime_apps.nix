{ config, lib, myLib, ... }:
  with lib;
  let
    cfg = config.custom.defaults.mimeApps;
  in
  {
    options.custom.defaults.mimeApps =
      mapAttrs
        (_: desc: mkOption {
          type = myLib.types.listOfOrSingleton types.str;
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
