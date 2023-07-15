_: {
  overlays =
    let
      overlay = self: super: {
        steam = super.steam.override {
          extraPkgs = pkgs: with pkgs; [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            keyutils
          ];
        };
      };
    in [ overlay ];
  
  config = {
    allowUnfree = true;
    # See https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = (_: true);
  };
}
