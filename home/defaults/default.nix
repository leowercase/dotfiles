{ myLib, ... }:
  { imports = myLib.getModules ./.; }