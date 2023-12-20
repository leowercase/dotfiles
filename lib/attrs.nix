{ lib, ... }:
  with builtins;
  with lib;
  {
    attrsToList = attrs:
      mapAttrsToList (name: value: { inherit name value; }) attrs;

    mapNames = f: set:
      mapAttrs' (n: v: nameValuePair (f n v) v) set;

    anyAttrs = pred: attrs:
      any ({ name, value }: pred name value) (attrsToList attrs);

    recursiveMergeAttrsList = foldl recursiveUpdate {};
  }
