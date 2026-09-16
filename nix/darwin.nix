{ pkgs, config, ... }:

{
  imports = [
    ./packages.nix
    ./homebrew.nix
  ];

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
}
