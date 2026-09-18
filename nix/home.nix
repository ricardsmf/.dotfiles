{ config, lib, ... }:

let
  dotfiles = "/Users/ricardoferreira/.dotfiles";

  # Link each entry of a repo directory individually rather than linking the
  # directory itself, the way stow did: the parent stays a real directory, so
  # runtime siblings (~/.claude/skills/synced, ~/.local/bin/claude) survive.
  # Targets are live repo paths, so configs stay editable without a rebuild.
  # `src` must be a path inside the flake (readDir at eval time); `from` is the
  # same location as a string, used only to build the symlink target.
  link =
    {
      src,
      from,
      to,
      types ? [
        "regular"
        "directory"
      ],
    }:
    lib.mapAttrs'
      (
        name: _:
        lib.nameValuePair "${to}/${name}" {
          source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${from}/${name}";
        }
      )
      (lib.filterAttrs (name: type: lib.elem type types && name != ".gitignore") (builtins.readDir src));
in
{
  imports = [ ./kitty.nix ];

  home.stateVersion = "26.11";

  home.file =
    link {
      src = ../home/.config;
      from = "home/.config";
      to = ".config";
    }
    // link {
      src = ../home/.claude;
      from = "home/.claude";
      to = ".claude";
      types = [ "regular" ];
    }
    // link {
      src = ../home/.claude/skills;
      from = "home/.claude/skills";
      to = ".claude/skills";
    }
    // link {
      src = ../home/.local/bin;
      from = "home/.local/bin";
      to = ".local/bin";
    };
}
