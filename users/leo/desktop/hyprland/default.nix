{ inputs, inputs', lib, config, pkgs, ... } @ args:
  with lib;
  let
    cfg = config.users'.leo.desktop.hyprland;
  in
  {
    imports = [ inputs.hyprland.nixosModules.default ];

    options.users'.leo.desktop.hyprland = {
      enable = mkEnableOption "my Hyprland";
    };

    config = mkIf cfg.enable {
      home-manager.users.leo.imports = [ inputs.hyprland.homeManagerModules.default ];

      programs.hyprland.enable = true;
      system'.audio = "pipewire";

      home-manager.users.leo.wayland.windowManager.hyprland = {
        enable = true;

        plugins = [ inputs'.hyprland-plugins.packages.hyprbars ];

        settings = mkMerge [
          (import ./settings.nix args)
          (import ./binds.nix args)
        ];

        extraConfig = import ./config.nix args;
      };

      home-manager.users.leo.home.packages = with pkgs; [
        wl-clipboard
        libsForQt5.polkit-kde-agent

        rofi-wayland
        inputs'.hyprland-contrib.packages.grimblast

        noto-fonts
        noto-fonts-emoji
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        (nerdfonts.override { fonts = [ "FiraCode" ]; })

        # See https://wiki.archlinux.org/title/Wayland#GUI_libraries
        libsForQt5.qt5.qtwayland
        qt6.qtwayland
      ];
    
      users'.leo.fonts.aliases = {
        serif = "Noto Serif";
        sans-serif = "Noto Sans";
        monospace = "FiraCode Nerd Font";
        emoji = "Noto Color Emoji";
      };

      users'.leo.programs = {
        swaylock-effects.enable = true;

        swayidle = {
          enable = true;
          screenLocker = "${pkgs.swaylock-effects}/bin/swaylock";
        };
      };

      home-manager.users.leo.services.dunst = {
        enable = true;
      };
    };
  }
