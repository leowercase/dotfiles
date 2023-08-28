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
            default_page = "qute://start";
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
	  # Search engines
          DEFAULT = "https://search.brave.com/search?q={}";
	  "!img" = "https://search.brave.com/images?q={}";

          # Wikis
          "!w" = "https://en.wikipedia.org/w/index.php?title=Special:Search&search={}";

          # Distro wikis
          "!aw" = "https://wiki.archlinux.org/index.php?search={}";
          "!now" = "https://nixos.wiki/index.php?search={}";
          "!gw" = "https://wiki.gentoo.org/index.php?search={}";
          "!vhb" = "https://docs.voidlinux.org/?search={}";

	  # Dictionaries
	  "!ubd" = "https://www.urbandictionary.com/define.php?term={}";

          # NixOS search engines
          "!pkgs" = "https://search.nixos.org/packages?query={}";
          "!opts" = "https://search.nixos.org/options?query={}";
          "!hm" = "https://mipmip.github.io/home-manager-option-search/?query={}";
          "!flakes" = "https://search.nixos.org/flakes?query={}";

	  # Git hosting platforms
          "!gh" = "https://github.com/{}";
          "!gl" = "https://gitlab.com/{}";
          "!cb" = "https://codeberg.org/{}";
	  "!sr" = "https://sr.ht/~{}";

          # Media
          "!od" = "https://odysee.com/$/search?q={}";
          "!yt" = "https://youtube.com/results?search_query={}";
          "!yt@" = "https://youtube.com/@{}";
          "!r" = "https://reddit.com/r/{}";
          "!rd" = "https://search.brave.com/search?q={} site%3Areddit.com";
        };
      };
    };
  }
