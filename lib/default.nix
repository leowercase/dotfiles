{ nixpkgs,
  nixpkgs-unstable,
  home-manager,
  ... } @ flake:
  let
    myLib =
      with builtins;
      with nixpkgs.lib;
      {
        # Both variants appear in my modules
        isNixFilePath = filePath:
          (sources.pathIsRegularFile filePath) &&
            (strings.hasSuffix ".nix" (baseNameOf filePath)); 
        isNixDirPath = filePath:
          (sources.pathIsDirectory filePath) &&
            (hasAttr "default.nix" (readDir filePath));
    
        # Used in the `imports` section of a module
        moduleImport = dir: filename:
          (let filePath = /${dir}/${filename}.nix;
            in if myLib.isNixFilePath filePath then [ filePath ] else [])
          ++
          (let dirPath = /${dir}/${filename};
            in if myLib.isNixDirPath dirPath then [ dirPath ] else []);

        # Get all files with a `.nix` extension and all subdirectories
        # with a `default.nix` in them from a directory
        getNixFiles = dir:
          let
            dirContents = readDir dir;
          in
          map
            (fileName: /${dir}/${fileName})
            (filter
              (fileName:
                let filePath = /${dir}/${fileName};
                in (myLib.isNixFilePath filePath) || (myLib.isNixDirPath filePath))
              (attrNames dirContents));

        # I usually import files from a `default.nix`, so this
        # removes **infinite recursion**
        getModules = dir:
          lists.remove /${dir}/default.nix (myLib.getNixFiles dir);

        mkFlake = dir: config:
          attrsets.foldAttrs
            (x: y: x // y)
            {}
            (attrValues (mapAttrs (hostname: cfg:
              let
                inherit (cfg) system;
	        overlays = import /${dir}/overlays;
                specialArgs = { inherit flake myLib hostname system overlays; };
              in
              {
                nixosConfigurations.${hostname} = nixosSystem {
                  inherit system specialArgs;
                  modules = [ /${dir}/modules ];
                };

                homeConfigurations =
                  listToAttrs
                    (map
                      (username: {
                        name = "${username}@${hostname}";
                        value = home-manager.lib.homeManagerConfiguration {
                          pkgs = nixpkgs-unstable.legacyPackages.${system};
                          modules = [ /${dir}/hmodules ];
                          extraSpecialArgs = specialArgs // { inherit username; };
                        };
                      })
                      cfg.hmUsers);
              })
              config));
      };
  in
  myLib
