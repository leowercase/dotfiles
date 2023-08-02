_: {
  overlays =
    let
      overlay = self: super: {
        # See https://github.com/NixOS/nixpkgs/issues/162562#issuecomment-1523177264
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
