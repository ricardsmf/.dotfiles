{
  pkgs,
  config,
  inputs,
  ...
}:

{
  imports = [
    ./packages.nix
    ./homebrew.nix
    inputs.paneru.darwinModules.paneru
  ];

  # home-manager derives homeDirectory from this.
  users.users.ricardoferreira.home = "/Users/ricardoferreira";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  # Stow owns most of ~/.config; back up rather than fail if the two collide.
  home-manager.backupFileExtension = "hm-bak";
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.users.ricardoferreira = import ./home.nix;

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # Required now that system activation runs as root: user-scoped options
  # (e.g. the homebrew module) apply to this user.
  system.primaryUser = "ricardoferreira";

  nix.enable = true;
  nix.package = pkgs.lixPackageSets.stable.lix;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # nix-darwin appends root on its own.
  nix.settings.trusted-users = [ "ricardoferreira" ];

  # Pure flakes: no channels. Without this, nixPath carries a root channels
  # profile that does not exist and every root eval warns about it. Keep
  # <nixpkgs> working by pointing it at the flake input instead.
  nix.channel.enable = false;
  nix.nixPath = [ { nixpkgs = "${inputs.nixpkgs}"; } ];

  # Determinate used to garbage-collect the store on its own; nix-darwin does not.
  nix.gc.automatic = true;
  nix.gc.interval = {
    Weekday = 7;
    Hour = 3;
    Minute = 0;
  };
  nix.gc.options = "--delete-older-than 30d";
  nix.optimise.automatic = true;

  # Register the nix-provided fish in /etc/shells so it can be the login shell.
  environment.shells = [ pkgs.fish ];
  programs.fish.enable = true;

  # Used for backwards compatibility — do not change after first switch.
  system.stateVersion = 5;

  services.tailscale.enable = true;
  services.paneru = {
    enable = true;
    # Paneru configuration
    # See CONFIGURATION.md for a list of all options
    settings = {
      options = {
        focus_follows_mouse = true;
        mouse_follows_focus = true;
        animation_speed = 15;
        preset_column_widths = [0.25 0.33 0.5 0.66 0.75 1.00];
      };
      bindings = {
        window_focus_west = "alt - h";
        window_focus_east = "alt - l";
        window_swap_west = "alt - shift - h";
        window_swap_east = "alt - shift - l";
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
