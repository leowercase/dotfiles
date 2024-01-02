{ lib, config, ... }:
  # See https://wiki.hyprland.org/Configuring/Binds for information
  let
    inherit (config.users'.leo.programs) default;

    # SUPER [SHIFT], '1'..'0', [moveto]workspace, 1..10
    workspaces = with builtins; with lib;
      concatLists (genList
        (x:
          let
            n = x + 1;
            char = toString (mod n 10);
            workspace = toString n;
          in
          [
            "SUPER, ${char}, workspace, ${workspace}"
            "SUPER SHIFT, ${char}, movetoworkspace, ${workspace}"
          ])
        10);
  in
  {
    bind = [
      # Basic stuff
      "SUPER, Q, exit"
      "SUPER, C, killactive,"
      "SUPER, T, togglefloating,"
      "SUPER, F, fullscreen,"
      "SUPER SHIFT, F, fakefullscreen,"

      # Movement
      "SUPER, J, cyclenext"
      "SUPER SHIFT, J, swapnext"
      "SUPER, K, cyclenext, prev"
      "SUPER SHIFT, K, swapnext, prev"

      # Running programs
      "SUPER, Return, exec, ${default.terminal}"
      "SUPER, B, exec, ${default.browser}"
      "SUPER, Slash, exec, rofi -show drun"
      "SUPER, S, exec, grimblast copy area"
      "SUPER SHIFT, S, exec, grimblast copy screen"

      # Grouping
      "SUPER, G, togglegroup"
      "SUPER, H, changegroupactive, b"
      "SUPER, L, changegroupactive, f"

      # Scrolling workspaces
      "SUPER, mouse_down, workspace, e+1"
      "SUPER, mouse_up, workspace, e-1"
    ]
      # Navigating workspaces
      ++ workspaces;

    bindl = [
      # Toggle mute
      "SUPER, I, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ];

    bindle = [
      # Volume control
      "SUPER, U, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"
      "SUPER, O, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2%+"
    ];

    bindm = [
      # Mouse movement
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, resizewindow"
    ];
  }
