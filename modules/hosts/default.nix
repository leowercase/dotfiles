{ myLib, hostname, ... }:
  { imports = myLib.moduleImport ./. hostname; }