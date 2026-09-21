{ inputs, ... }:

{
  imports = [ inputs.paneru.darwinModules.paneru ];

  services.paneru = {
    enable = true;
    settings = {
      options = {
        focus_follows_mouse = true;
        mouse_follows_focus = true;
        horizontal_mouse_warp = 1;
        animation_speed = 15;
        preset_column_widths = [
          0.25
          0.33
          0.5
          0.66
          0.75
          1.00
        ];
      };
      bindings = {
        window_focus_west = "alt - h";
        window_focus_east = "alt - l";
        window_focus_north = "alt - j";
        window_focus_south = "alt - k";
        window_swap_west = "alt + shift - h";
        window_swap_east = "alt + shift - l";
        window_swap_north = "alt + shift - j";
        window_swap_south = "alt + shift - k";
        window_resize = "alt - r";
        window_shrink = "alt - s";
        window_center = "alt - c";
        window_balance = "alt - b";
        quit = "ctrl + alt - q";
      };
      swipe = {
        deceleration = 0.4;
        sensitivity = 0.4;
        continuous = false;
        gesture = {
          fingers_count = 3;
          direction = "Natural";
        };
      };
    };
  };
}
