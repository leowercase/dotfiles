{ lib, customLib, ... }: { imports = customLib.getModules'' ./.; }
