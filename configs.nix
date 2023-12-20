{ inputs, customLib, ... }: {
  flake.nixosConfigurations = customLib.mkConfigurations {
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
  };
}
