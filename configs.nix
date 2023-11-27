{ flake, lib, ... }: {
  nixosConfigurations = lib.custom.mkConfigurations {
    inherit (flake) nixpkgs;
    hosts = {
      dekstop = {
        system = "x86_64-linux";
        modules = [ ./hosts/dekstop.nix ];
      };
      latpop = {
        system = "x86_64-linux";
        modules = [ ./hosts/latpop.nix ];
      };
    };
    modules = [ ./system ./users ];
    specialArgs = { inherit flake; };
  };
}
