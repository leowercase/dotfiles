# This module handles commands of default programs and sets
# environment variables accordingly. Options defined here are
# used by other modules as well
{ config, lib, customLib, ... }:
  with lib;
  let
    cfg = config.users'.leo.programs.default;
  in
  {
    imports = customLib.getModules'' ./.;

    options.users'.leo.programs.default =
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

    # See https://wiki.archlinux.org/title/Environment_variables#Default_programs
    config.home-manager.users.leo.home.sessionVariables =
      attrsets.mergeAttrsList
        (attrValues (mapAttrs
          (name: envs:
            let command = cfg.${name};
            in genAttrs envs (_: command))
          {
            shell = singleton "SHELL";
            pager = singleton "PAGER";
            editor = [ "EDITOR" "VISUAL" ];
            browser = singleton "BROWSER";
          }));
  }
