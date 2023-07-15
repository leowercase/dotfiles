{ myLib, ... }:
  {
    imports = myLib.getModules ./.;

    # My shell
    programs.bash = {
      enable = true;
      enableCompletion = true;
    };

    # Editor alias, because I'm lazy
    home.shellAliases.e = "$EDITOR";
  }
