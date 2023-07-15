# This module handles commands of default programs and sets
# environment variables accordingly. Options defined here can be
# used by other modules as well. The XDG MIME Applications specification
# uses desktop entries instead of commands used to invoke default
# programs, so they are handled separately by `custom.mimeDefaults`
{ config, lib, ... }:
  with lib;
  let
    cfg = config.custom.defaultPrograms;
  in
  {
    options.custom.defaultPrograms =
      attrsets.mapAttrs
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
