{ customLib, ... }: { imports = customLib.getModules'' ./.; }
