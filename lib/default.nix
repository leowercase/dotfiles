lib:
  let
    custom =
      with builtins;
      with lib;
      attrsets.mergeAttrsList (map
        (file: if file == "default.nix" then {} else import ./${file} lib')
        (attrNames (readDir ./.)));

    lib' = lib.extend (_: _: { inherit custom; });
  in
  lib'
