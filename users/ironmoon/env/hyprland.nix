{ config, lib, ... }:
let
  workspaceBinding =
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
    bindings ++ moveBindings;

  terminal = "kitty";
  emacs = "emacs";
  fileManager = "dolphin";
  browser = "firefox -new-tab";
  menu = "anyrun";
  clipboardHist = "cliphist list | wofi --dmenu | cliphist decode | wl-copy";
  ssWindow = "hyprshot -m window";
  ssMonitor = "hyprshot -m output";
  ssSelection = "hyprshot -m region -z";
  colorPick = "hyprpicker -a -n -q";
in
{
  enable = config.host.hyprland;

  # conflicts with uwsm
  systemd.enable = false;

  settings = {
    source = "~/.config/hypr/monitors.conf";

    exec-once = [
      "wl-paste --type text --watch cliphist -max-items 100000 store"
      "wl-paste --type image --watch cliphist -max-items 100000 store"
    ];

    env =
      [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "NIXOS_OZONE_WL,1"
        "XDG_MENU_PREFIX,plasma-"
      ]
      ++ lib.optionals config.host.nvidia [
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
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
      # disable_autoreload = true;
    };

    gestures = {
      workspace_swipe = true;
    };

    render.explicit_sync = lib.mkIf config.host.nvidia 0;

    # https://wiki.hyprland.org/Configuring/Binds/, wev to inspect
    bind = [
      "SUPER, T, exec, ${terminal}"
      "SUPER, E, exec, ${emacs}"
      "SUPER, D, exec, ${fileManager}"
      "SUPER, B, exec, ${browser}"
      "SUPER, Q, killactive,"
      "SUPER, SHIFT ALT Q, forcekillactive,"
      "SUPER SHIFT, Delete, exec, uwsm stop"
      "SUPER, F, togglefloating,"
      "SUPER, G, fullscreen,"
      "SUPER, SPACE, exec, ${menu}"
      "ALT`, SPACE, exec, ${menu}"
      "SUPER, P, pseudo," # dwindle
      "SUPER, J, togglesplit," # dwindle

      # clipboard
      "SUPER, V, exec, ${clipboardHist}"

      # screenshot
      "SUPER, PRINT, exec, ${ssWindow}"
      ", PRINT, exec, ${ssMonitor}"
      "SUPER SHIFT, PRINT, exec, ${ssSelection}"
      "SUPER SHIFT, s, exec, ${ssSelection}"

      # color picker
      "SUPER SHIFT, c, exec, ${colorPick}"

      # lock
      "SUPER, L, exec, loginctl lock-session"

      # Move focus with mainMod + arrow keys
      "SUPER, left, movefocus, l"
      "SUPER, right, movefocus, r"
      "SUPER, up, movefocus, u"
      "SUPER, down, movefocus, d"

      # Example special workspace (scratchpad)
      "SUPER, grave, togglespecialworkspace, magic"
      "SUPER SHIFT, grave, movetoworkspace, special:magic"

      # Scroll through existing workspaces with mainMod + scroll
      "SUPER, mouse_down, workspace, e+1"
      "SUPER, mouse_up, workspace, e-1"

      "SUPER CTRL, left, workspace, m-1"
      "SUPER CTRL, right, workspace, m+1"
      "SUPER CTRL ALT, left, workspace, r-1"
      "SUPER CTRL ALT, right, workspace, r+1"
    ] ++ workspaceBinding;

    binde = [
      # zooming, inspired by https://reddit.com/comments/1c61h25/-/m444x7r
      "SUPER, equal,     exec, hyprctl keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 + ($2 * 0.1)}')"
      "SUPER, minus,     exec, hyprctl keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 - ($2 * 0.1)}')"
      "SUPER, BackSpace, exec, hyprctl keyword cursor:zoom_factor 1"
    ];

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
      ",XF86MonBrightnessUp, exec, brightnessctl s 5%+"
      ",XF86MonBrightnessDown, exec, brightnessctl s 5%-"
    ];

    bindl = [
      # Requires playerctl
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
    ];

    windowrulev2 = [
      # Ignore maximize requests from apps.
      "suppressevent maximize, class:.*"
      # Fix some dragging issues with XWayland
      "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

      "opacity 0, class:xwaylandvideobridge"
      "noanim, class:xwaylandvideobridge"
      "workspace special silent, class:xwaylandvideobridge"

      "float,title:^(Orbital)$"

      # TODO: make xdg-portals float
    ];

    layerrule = [
      "blur, (anyrun)"
      "ignorezero, (anyrun)"
    ];
  };
}
