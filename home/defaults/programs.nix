# This module handles commands of default programs and sets
# environment variables accordingly. Options defined here can be
# used by other modules as well
{ config, lib, ... }:
  with lib;
  let
    cfg = config.custom.defaults.programs;
  in
  {
    options.custom.defaults.programs =
      mapAttrs
        (_: desc: mkOption {
          type = types.str;
          default = "";
          description = "The default ${desc} to use.";
        })
        {
          shell = "command-line shell";
	  pager = "pager program";
          editor = "text editor";
          terminal = "terminal emulator";
          browser = "web browser";
	};

    config = {
      home.sessionVariables =
        concatMapAttrs
	  (programName: envs:
	    let
	      command = cfg.${programName};
	      envs' = toList envs;
	    in
	    if command != ""
	      then listToAttrs (map
	        (env: nameValuePair env command)
		envs')
	      else {})
	  {
            shell = "SHELL";
            pager = "PAGER";
            editor = [ "EDITOR" "VISUAL" ];
            browser = "BROWSER";
	  };
    };
  }
