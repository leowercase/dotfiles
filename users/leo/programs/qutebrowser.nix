{ config, lib, ... }:
  with lib;
  let
    cfg = config.users'.leo.programs.qutebrowser;
  in
  {
    options.users'.leo.programs.qutebrowser = {
      enable = mkEnableOption "my qutebrowser";
    };

    config.home-manager.users.leo = mkIf cfg.enable {
      programs.qutebrowser = {
        enable = true;

        settings = {
          content = {
            autoplay = false;
            geolocation = false;
            headers.do_not_track = true;
            pdfjs = true;
          };
          # Come to the Dark Side, we have less eye strain
          colors.webpage.preferred_color_scheme = "dark";
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
          # Search engines
          DEFAULT = "https://search.brave.com/search?q={}";
          "!img" = "https://search.brave.com/images?q={}";

          # Wikis
          "!w" = "https://en.wikipedia.org/w/index.php?title=Special:Search&search={}";
          "!aw" = "https://wiki.archlinux.org/index.php?search={}";
          "!now" = "https://nixos.wiki/index.php?search={}";

          # Dictionaries
          "!ubd" = "https://www.urbandictionary.com/define.php?term={}";

          # Nix search engines
          "!ng" = "https://noogle.dev/?term=%22{}%22";
          "!pkgs" = "https://search.nixos.org/packages?query={}";
          "!opts" = "https://search.nixos.org/options?query={}";
          "!hm" = "https://mipmip.github.io/home-manager-option-search/?query={}";
          "!flakes" = "https://flakestry.dev/?q={}";
          "!nixvim" = "https://nix-community.github.io/nixvim/?search={}";

          # Git hosting platforms
          "!gh" = "https://github.com/{}";
          "!gl" = "https://gitlab.com/{}";
          "!cb" = "https://codeberg.org/{}";
          "!sr" = "https://sr.ht/~{}";

          # Media
          "!yt" = "https://youtube.com/results?search_query={}";
          "!yt@" = "https://youtube.com/@{}";
          "!od" = "https://odysee.com/$/search?q={}";
          "!r" = "https://reddit.com/r/{}";
        };
      };
    };
  }
