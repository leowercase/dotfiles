{ config, lib, ... }:
  with lib;
  let
    cfg = config.my.programs.qutebrowser;
  in
  {
    options.my.programs.qutebrowser = {
      enable = mkEnableOption "my qutebrowser";
    };

    config = mkIf cfg.enable {
      programs.qutebrowser = {
        enable = true;

        settings = {
          content = {
            autoplay = false;
            geolocation = false;
            headers.do_not_track = true;
          };
          scrolling = {
            bar = "never";
            smooth = true;
          };
          url = rec {
            default_page = "https://search.brave.com/";
            start_pages = default_page;
            open_base_url = true;
          };
        };

        keyBindings = {
          normal = {
            cs = "config-source";
            xf = "jseval -q document.activeElement.blur()";
            ch = "history-clear";
          };
        };
        
        searchEngines = {
          DEFAULT = "https://search.brave.com/search?q={}";

          # Distro wikis
          "!aw" = "https://wiki.archlinux.org/index.php?search={}";
          "!now" = "https://nixos.wiki/index.php?search={}";
          "!gw" = "https://wiki.gentoo.org/index.php?search={}";
          "!vhb" = "https://docs.voidlinux.org/?search={}";

          # NixOS search engines
          "!pkgs" = "https://search.nixos.org/packages?query={}";
          "!opts" = "https://search.nixos.org/options?query={}";
          "!hm" = "https://mipmip.github.io/home-manager-option-search/?query={}";
          "!flakes" = "https://search.nixos.org/flakes?query={}";

          # Media
          "!od" = "https://odysee.com/$/search?q={}";
          "!yt" = "https://youtube.com/results?search_query={}";
          "!r" = "https://reddit.com/r/{}";
          "!rd" = "https://search.brave.com/search?q={} site%3Areddit.com";
        };
      };
    };
  }
