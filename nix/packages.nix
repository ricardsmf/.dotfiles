{ pkgs, inputs, ... }:

{
  # CLI tools, native nixpkgs. Sorted by attribute name; `dot package add <x>`
  # (type pkg) inserts here. Rust toolchain = cargo + rustc + clippy + rustfmt.
  environment.systemPackages = with pkgs; [
    ast-grep
    awscli2
    btop
    cargo
    clippy
    cloc
    cloudflared
    cmake
    deno
    direnv
    doggo
    doppler
    fd
    ffmpeg
    fish
    fzf
    gh
    gnupg
    gnused
    jq
    jujutsu
    just
    kitty
    lazygit
    llvm
    llvm.dev # provides llvm-config (separate dev output)
    mpv
    neovim
    python314
    ripgrep
    rustc
    rustfmt
    shellcheck
    starship
    stow
    stylua
    tailscale
    tree
    tree-sitter
    wasm-tools
    wasmtime
    wget
    yazi
    zig
    zoxide
  ];
}
