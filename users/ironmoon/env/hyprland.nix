{ ... }:
{
  enable = true;

  # conflicts with uwsm
  systemd.enable = false;

  settings = {

    "$terminal" = "kitty";
    "$fileManager" = "dolphin";
    "$menu" = "wofi --show drun";

    exec-once = [
      "nm-applet --indicator &"
      "killall waybar; waybar &"
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
    ];

    monitor = ",preferred,auto,1";

    env = [
      "XCURSOR_SIZE,24"
      "HYPRCURSOR_SIZE,24"
    ];

    general = {
      gaps_in = 0;
      gaps_out = 0;
      border_size = 1;

      "col.active_border" = "rgba(33ccffee)";
      "col.inactive_border" = "rgba(595959aa)";

      resize_on_border = true;
      extend_border_grab_area = 20;

      layout = "dwindle";
    };

    decoration = {
      rounding = 0;
      shadow.enabled = false;
      blur.enabled = false;
    };

    animations.enabled = false;

    input = {
      touchpad = {
        clickfinger_behavior = true;
        natural_scroll = true;
      };
    };

    # TODO: https://wiki.hyprland.org/Configuring/Dwindle-Layout/
    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    # https://wiki.hyprland.org/Configuring/Variables/#misc
    misc = {
      force_default_wallpaper = 0;
      disable_splash_rendering = true;
      focus_on_activate = true;
      disable_autoreload = true;
    };

    gestures = {
      workspace_swipe = true;
    };

    # https://wiki.hyprland.org/Configuring/Binds/
    bind =
      [
        "SUPER, T, exec, $terminal"
        "SUPER, Q, killactive,"
        "SUPER, SHIFT ALT Q, forcekillactive,"
        "SUPER, M, exec, uwsm stop"
        "SUPER, E, exec, $fileManager"
        "SUPER, F, togglefloating,"
        "SUPER, G, fullscreen,"
        "SUPER, SPACE, exec, $menu"
        "SUPER, P, pseudo," # dwindle
        "SUPER, J, togglesplit," # dwindle

        # clipboard
        "SUPER, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"

        # screenshot
        "SUPER, PRINT, exec, hyprshot -m window"
        ", PRINT, exec, hyprshot -m output"
        "SUPER SHIFT, PRINT, exec, hyprshot -m region"

        # lock
        # "SUPER, L, exec, hyprlock"

        # Move focus with mainMod + arrow keys
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"

        # Example special workspace (scratchpad)
        "SUPER, S, togglespecialworkspace, magic"
        "SUPER SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mainMod + scroll
        "SUPER, mouse_down, workspace, e+1"
        "SUPER, mouse_up, workspace, e-1"

        "SUPER CTRL, left, workspace, m-1"
        "SUPER CTRL, right, workspace, m+1"
      ]
      ++ (
        with builtins;
        let
          mod = x: y: x - (x / y) * y;
          keys = genList (x: if x < 10 then toString (mod (x + 1) 10) else "F" + toString (x - 9)) 20;
          workspaces = genList (x: toString (x + 1)) 20;
          altWorkspaces = genList (x: toString (x + 31)) 20;

          mkBinding =
            mod: key: ws:
            "${mod}, ${key}, workspace, ${ws}";
          mkMoveBinding =
            mod: key: ws:
            "${mod}, ${key}, movetoworkspace, ${ws}";

          # Switch workspaces with SUPER (ALT)?, [1-9]|F[1-10]
          bindings =
            genList (i: mkBinding "SUPER" (elemAt keys i) (elemAt workspaces i)) 20
            ++ genList (i: mkBinding "SUPER ALT" (elemAt keys i) (elemAt altWorkspaces i)) 20;

          # Move active window to a workspace with SUPER (ALT)?, [1-9]|F[1-10]
          moveBindings =
            genList (i: mkMoveBinding "SUPER SHIFT" (elemAt keys i) (elemAt workspaces i)) 20
            ++ genList (i: mkMoveBinding "SUPER SHIFT ALT" (elemAt keys i) (elemAt altWorkspaces i)) 20;

        in
        bindings ++ moveBindings
      );

    bindm = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, resizewindow"
    ];

    bindel = [
      # Laptop multimedia keys for volume and LCD brightness
      ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
      ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
    ];

    bindl = [
      # Requires playerctl
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
    ];

    windowrulev2 = [
      # Ignore maximize requests from apps. You'll probably like this.
      "suppressevent maximize, class:.*"
      # Fix some dragging issues with XWayland
      "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

      # todo: make xdg-portals float
    ];
  };
}
