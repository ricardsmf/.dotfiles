# Kitty, declared through home-manager's `programs.kitty` instead of a linked
# kitty.conf. home-manager renders ~/.config/kitty/kitty.conf into the store
# and signals running kitty instances to reload it on `darwin-rebuild switch`.
#
# The package itself stays in nix/packages.nix (nix-darwin's
# environment.systemPackages) so kitty.app keeps living in
# /Applications/Nix Apps, where karabiner's launcher shortcut expects it;
# `package = null` stops home-manager from installing a second copy.
{ config, lib, ... }:

let
  # kitty-scrollback.nvim is installed by lazy.nvim; kitty runs its kitten
  # straight out of that checkout.
  ksb = "${config.home.homeDirectory}/.local/share/nvim/lazy/kitty-scrollback.nvim";
in
{
  programs.kitty = {
    enable = true;
    package = null;

    font = {
      name = "JetBrains Mono";
      size = 16;
    };

    # Same file kitty-themes ships as the previously vendored
    # catpuccin-frappe.conf; only the include path changes.
    themeFile = "Catppuccin-Frappe";

    # Fish sources kitty's shell integration itself
    # (home/.config/fish/conf.d/kitty.fish), so kitty must not inject it.
    # `null` keeps the module from adding its own `no-rc`; the explicit
    # `disabled` in settings below is what kitty sees, as before.
    shellIntegration.mode = null;

    settings = {
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      text_composition_strategy = "1.0 0";
      shell_integration = "disabled";
      enable_audio_bell = false;
      visual_bell_duration = "0.0";
      macos_option_as_alt = "left";
      allow_remote_control = true;
      listen_on = "unix:/tmp/kitty";
      select_by_word_characters = "@-./_~?&=%+#";
      show_hyperlink_targets = true;
      copy_on_select = true;
      enabled_layouts = "splits,stack";
      tab_bar_edge = "left";
      tab_bar_style = "separator";
      tab_bar_show_new_bar = "yes";
    };

    actionAliases = {
      kitty_scrollback_nvim = "kitten ${ksb}/python/kitty_scrollback_nvim.py";
      launch_tab = "launch --cwd=current --type=tab";
      launch_window = "launch --cwd=current";
    };

    keybindings = {
      # kitty-scrollback.nvim: browse the scrollback buffer / the last
      # command's output in nvim
      "cmd+s" = "kitty_scrollback_nvim";
      "cmd+g" = "kitty_scrollback_nvim --config ksb_builtin_last_cmd_output";

      "cmd+c" = "copy_to_clipboard";
      "cmd+v" = "paste_from_clipboard";

      # delete whole line back to cursor
      "cmd+backspace" = "send_text all \\x15";
      # clear the terminal screen
      "cmd+shift+backspace" = "combine : clear_terminal scrollback active : send_text all \\x0c";

      # jump to beginning and end of word
      "alt+left" = "send_text all \\x1b\\x62";
      "alt+right" = "send_text all \\x1b\\x66";

      # jump to beginning and end of line
      "cmd+left" = "send_text all \\x01";
      "cmd+right" = "send_text all \\x05";

      # changing font sizes
      "cmd+equal" = "change_font_size all +2.0";
      "cmd+minus" = "change_font_size all -2.0";
      "cmd+0" = "change_font_size all 0";

      # navigate between windows
      "cmd+h" = "neighboring_window left";
      "cmd+l" = "neighboring_window right";
      "cmd+k" = "neighboring_window down";
      "cmd+j" = "neighboring_window up";
      "cmd+d" = "close_window";

      # resize the active split
      "cmd+shift+h" = "resize_window narrower";
      "cmd+shift+l" = "resize_window wider";
      "cmd+shift+k" = "resize_window taller";
      "cmd+shift+j" = "resize_window shorter";

      # create splits (new window inherits current dir)
      "cmd+enter" = "launch --cwd=current --location=vsplit";
      "cmd+shift+enter" = "launch --cwd=current --location=hsplit";
      # toggle a single window to fullscreen (uses the stack layout)
      "cmd+f" = "toggle_layout stack";

      "f1" = "launch_window nvim";
      "f2" = "launch_window lazygit";
      "f3" = "launch_window yazi";
    }
    # cmd+<num> jumps to the corresponding tab
    // lib.listToAttrs (
      map (n: lib.nameValuePair "cmd+${toString n}" "goto_tab ${toString n}") (lib.range 1 9)
    );

    mouseBindings = {
      # show clicked command output in nvim
      "ctrl+shift+right press ungrabbed" =
        "combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output";
      "ctrl+left press ungrabbed,grabbed" = "mouse_click_url";
      "ctrl+alt+left press ungrabbed" = "mouse_selection rectangle";
      "left doublepress ungrabbed" = "mouse_selection word";
      "left press ungrabbed" = "mouse_selection normal";
    };
  };
}
