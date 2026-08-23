{ ... }:

{
  # GUI casks + custom-tap formulas stay on Homebrew, declared here so
  # `darwin-rebuild switch` drives `brew bundle` for them.
  # `dot package add cask <x>` inserts into `casks` below.
  homebrew = {
    enable = true;

    onActivation = {
      # Fully declarative: uninstall (and zap) any cask/brew not listed here.
      # Any intentional brew formula must be declared in `brews` below or
      # migrated to nixpkgs (nix/packages.nix), or it will be removed on switch.
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    # Third-party taps require `trusted = true` since Homebrew 6.0 (tap trust),
    # or `brew bundle` refuses to load their formulas during activation.
    taps = [
      { name = "dmmulroy/tap"; trusted = true; }
      { name = "modem-dev/tap"; trusted = true; }
    ];

    # Formulas with no nixpkgs equivalent or from custom taps.
    # `dot package add <x> brew` inserts into `brews` below.
    # (fisher is vendored into home/.config/fish/functions/fisher.fish instead —
    # the brew formula pulled in fish as a dependency and its function wasn't
    # visible to the nix fish.)
    brews = [
      "bookokrat"
      "hunk"
      "vite-plus"
    ];

    casks = [
      "claude-code"
      "cleanshot"
      "orbstack"
      "raycast"
      "yaak@beta"
    ];
  };
}
