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
    ./paneru.nix
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

  # Keys live outside the repo and the store (root-only, created by hand).
  networking.wg-quick.interfaces.vpn = {
    address = [ "10.9.0.2/32" ];
    privateKeyFile = "/etc/wireguard/keys/vpn.key";
    peers = [
      {
        publicKey = "ViSB3x8ltJaA0cixQ+ZeYE/csollKughWNTpymwGr1U=";
        presharedKeyFile = "/etc/wireguard/keys/vpn.psk";
        endpoint = "wg.ricardsmf.me:51820";
        allowedIPs = [ "10.9.0.0/24" ];
        persistentKeepalive = 25;
      }
    ];
  };

  # launchd socket-activates sshd on every interface (ListenAddress is ignored),
  # so AllowUsers is what limits logins to the WireGuard subnet.
  services.openssh = {
    enable = true;
    extraConfig = ''
      PasswordAuthentication no
      KbdInteractiveAuthentication no
      PermitRootLogin no
      AllowUsers ricardoferreira@10.9.0.0/24
    '';
  };
}
