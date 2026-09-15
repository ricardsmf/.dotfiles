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

  # Determinate manages the Nix installation/daemon itself, so nix-darwin must
  # not. (flakes + nix-command are already enabled system-wide by Determinate.)
  nix.enable = false;

  # Register the nix-provided fish in /etc/shells so it can be the login shell.
  environment.shells = [ pkgs.fish ];
  programs.fish.enable = true;

  # Vicinae is a background (LSUIElement) app: the darwin build installs the
  # server at Vicinae.app/Contents/MacOS/Vicinae, while bin/vicinae is only the
  # client CLI. Upstream ships a systemd unit, which is Linux-only, so the
  # server is supervised by launchd here instead.
  launchd.user.agents.vicinae = {
    command = "${pkgs.vicinae}/Applications/Vicinae.app/Contents/MacOS/Vicinae";
    serviceConfig = {
      RunAtLoad = true;
      # Crashed rather than plain `true`, so `vicinae` quit on purpose stays quit.
      KeepAlive.Crashed = true;
      StandardOutPath = "/Users/${config.system.primaryUser}/Library/Logs/vicinae.log";
      StandardErrorPath = "/Users/${config.system.primaryUser}/Library/Logs/vicinae.err.log";
    };
  };

  # AeroSpace works more reliably with one Space spanning both displays, and
  # wants Mission Control to group windows by app.
  # spans-displays = true means "Displays have separate Spaces" is OFF.
  # Takes effect on next logout, not on switch.

  # Used for backwards compatibility — do not change after first switch.
  system.stateVersion = 5;

  services.tailscale.enable = true;
}
