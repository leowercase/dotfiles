_: {
  programs.nixvim = {
    luaLoader.enable = true;
    clipboard.register = "unnamedplus";
    options = {
      number = true;
      relativenumber = true;
      
      termguicolors = true;
    };
  };
}
