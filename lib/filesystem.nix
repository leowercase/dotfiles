lib: _:
  with builtins;
  with lib;
  {
    innerImport = i: if (typeOf i) == "path" then import i else i;

    isImportable = p:
      let
        fileCond = (pathIsRegularFile p) && (hasSuffix ".nix" (baseNameOf p));
        dirCond = (pathIsDirectory p) && (pathExists /${p}/default.nix);
      in
      fileCond || dirCond;

    removeFileExtension = filename:
      let
        filenameParts = splitString "." filename;
        firstPart = elemAt filenameParts 0;
        hiddenFile = firstPart == "";
      in
        if hiddenFile then "." + (elemAt filenameParts 1) else firstPart;
    
    readDirNames = dir: attrNames (readDir dir);

    readDirPaths = dir:
      map (filename: /${dir}/${filename}) (custom.readDirNames dir);

    importDir = dir:
      mapAttrs
        (filename: _:
          let filePath = /${dir}/${filename};
          in (if custom.isImportable filePath
              then import filePath else readFile filePath))
        (readDir dir);

    getModules = dir:
      filter custom.isImportable (custom.readDirPaths dir);

    # If the file that the modules are imported from is in
    # the same directory, *infinite recursion* ensues
    getModules' = dir: fromFile:
      remove fromFile (custom.getModules dir);

    # Often the file that declares imports is default.nix
    getModules'' = dir: custom.getModules' dir /${dir}/default.nix;
  }
