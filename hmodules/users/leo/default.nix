{ myLib, ... }:
  {
    imports = myLib.getModules ./.;

    # My shell
    programs.bash = {
      enable = true;
      enableCompletion = true;
    };
  }
