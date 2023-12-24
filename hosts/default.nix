{ inputs, ... }: {
  systemConfigs = {
    hosts = {
      dekstop = {
        system = "x86_64-linux";
        modules = ./dekstop.nix;
      };
      latpop = {
        system = "x86_64-linux";
        modules = ./latpop.nix;
      };
    };

    common = { inputs', self', ... }: {
      modules = [ ../system ../users ];
      specialArgs = {
        inherit inputs inputs' self';
        customLib = self'.lib;
      };
    };
  };
}
