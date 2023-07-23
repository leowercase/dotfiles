{ nixpkgs,
  nixpkgs-unstable,
  home-manager,
  ... } @ flake:
  let
    myLib =
      with builtins;
      with nixpkgs.lib;
      rec {
	types = with nixpkgs.lib.types; {
          listOfOrSingleton = t: coercedTo (either (listOf t) t) toList (listOf t);
	};

        # Both variants appear in my modules
        isNixFilePath = filePath:
          (pathIsRegularFile filePath) &&
            (hasSuffix ".nix" (baseNameOf filePath)); 
        isNixDirPath = filePath:
          (pathIsDirectory filePath) &&
            (hasAttr "default.nix" (readDir filePath));
        
	filenamesInDir = dir: attrNames (readDir dir);
    
        # Get all files with a `.nix` extension and all subdirectories
        # with a `default.nix` in them from a directory
        getNixFiles = dir:
          map
            (filename: /${dir}/${filename})
            (filter
              (filename:
                let filePath = /${dir}/${filename};
                in (isNixFilePath filePath) || (isNixDirPath filePath))
              (filenamesInDir dir));

        # I usually import files from a `default.nix`, so this
        # removes **infinite recursion**
        getModules = dir: remove /${dir}/default.nix (getNixFiles dir);

        moduleImport = dir: filename:
	  let
	    dirPath = /${dir}/${filename};
            filePath = /${dir}/${filename}.nix;
	  in
          (optional (isNixDirPath dirPath) dirPath)
          ++ (optional (isNixFilePath filePath) filePath);

        mkFlake = dir: config:
          foldAttrs mergeAttrs {}
            (map
	      (filename:
                let
		  hostname = removeSuffix ".nix" filename;
                  system = config.${hostname};
		  nixpkgsConfig = { nixpkgs = import /${dir}/pkgs flake; };
                  specialArgs = { inherit flake myLib hostname system; };
		  users =
		    flatten (map
		      (filename:
		        let username = removeSuffix ".nix" filename;
		        in optional
			  (hasSuffix "@${hostname}" username)
			  (removeSuffix "@${hostname}" username))
		      (filenamesInDir /${dir}/users));
                in
                {
                  nixosConfigurations.${hostname} = nixosSystem {
                    inherit system specialArgs;
                    modules =
		      [ nixpkgsConfig /${dir}/modules ]
		      ++ (moduleImport /${dir}/hosts hostname);
                  };

                  homeConfigurations =
                    listToAttrs
                      (map
                        (username: {
                          name = "${username}@${hostname}";
                          value = home-manager.lib.homeManagerConfiguration {
                            pkgs = nixpkgs-unstable.legacyPackages.${system};
                            modules =
			      [ nixpkgsConfig /${dir}/home ]
			      ++ (moduleImport /${dir}/users username)
			      ++ (moduleImport /${dir}/users "${username}@${hostname}");
                            extraSpecialArgs = specialArgs // { inherit username; };
                          };
                        })
                        users);
                })
              (filenamesInDir /${dir}/hosts));
      };
  in
  myLib
