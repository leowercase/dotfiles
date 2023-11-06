{ config, ... }:
  with config.users'.leo.programs.default;
  ''
    # See https://wiki.hyprland.org/ for information
    
    env = XCURSOR_SIZE, 24

    general {
        layout = master
        gaps_in = 0
        gaps_out = 0
        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        col.inactive_border = rgba(595959aa)
    }

    animations {
        enabled = true

        bezier = myBezier, 0.05, 0.9, 0.1, 1.05

        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
    }

    master {
        new_is_master = true
        no_gaps_when_only = 1
    } 

    gestures {
        workspace_swipe = false
    }

    misc {
        vrr = 1
        disable_splash_rendering = true
        disable_hyprland_logo = true
    }

    $mainMod = SUPER

    bind = $mainMod, Q, exit
    bind = $mainMod, C, killactive,
    bind = $mainMod, T, togglefloating,
    bind = $mainMod, F, fullscreen,
    bind = $mainMod SHIFT, F, fakefullscreen,

    bind = $mainMod, Return, exec, ${terminal}
    bind = $mainMod, B, exec, ${browser}
    bind = $mainMod, Slash, exec, rofi -show drun
    bind = $mainMod, S, exec, grimblast copy area
    bind = $mainMod SHIFT, S, exec, grimblast copy screen

    bind = $mainMod, J, cyclenext
    bind = $mainMod SHIFT, J, swapnext
    bind = $mainMod, K, cyclenext, prev
    bind = $mainMod SHIFT, K, swapnext, prev

    binde = $mainMod, U, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-
    bind = $mainMod, I, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    binde = $mainMod, O, exec, wpctl set-volume -l ${builtins.toString config.users'.leo.desktop.sound.volumeLimit} @DEFAULT_AUDIO_SINK@ 2%+
    
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10

    bind = $mainMod, mouse_down, workspace, e+1
    bind = $mainMod, mouse_up, workspace, e-1

    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow
  ''
