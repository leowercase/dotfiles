{ inputs, ... }:
  let
    inherit (inputs.nixpkgs) lib;

    custom =
      with builtins;
      with lib;
      attrsets.mergeAttrsList (map
        (file: if file == "default.nix" then {} else import ./${file} lib')
        (attrNames (readDir ./.)));

    lib' = lib.extend (_: _: { inherit custom; });
  in
  {
    flake = {
      lib = custom;
      inherit (lib');
    };

    _module.args = { inherit custom; };
  }
