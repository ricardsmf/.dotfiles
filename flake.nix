{
  description = "ricardoferreira dotfiles — nix-darwin package management (incremental)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    hunk = {
        url = "github:modem-dev/hunk";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    herdr = {
        url = "github:ogulcancelik/herdr";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, nix-darwin, hunk, herdr }:
    {
      darwinConfigurations."PT-RICARDOFERREIRA" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [ ./nix/darwin.nix ];
      };

      darwinPackages = self.darwinConfigurations."PT-RICARDOFERREIRA".pkgs;
    };
}
