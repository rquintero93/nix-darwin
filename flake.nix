{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";
      nix.enable = false;
      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
        
      # Declare the user that will be running `nix-darwin`.
      users.users.ricardoquintero = {
          name = "ricardoquintero";
          home = "/Users/ricardoquintero";
      };

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
          pkgs.git
          pkgs.wget
          pkgs.curl
          pkgs.awscli
          pkgs.zsh
          pkgs.cmake
          pkgs.zip
          pkgs.antidote
          pkgs.atuin
          pkgs.fastfetch
          pkgs.sesh
          pkgs.tmux
          pkgs.zoxide
          pkgs.fzf
          pkgs.ripgrep
          pkgs.eza
          pkgs.neovim
          pkgs.nodejs
          pkgs.python3
          pkgs.uv
          pkgs.btop
          pkgs.fd
          pkgs.delta
          pkgs.git-extras
          pkgs.glow
          pkgs.starship
          pkgs.yazi
          pkgs.tree-sitter
          pkgs.chezmoi
          pkgs.bat
          pkgs.gh
          pkgs.lazygit
          pkgs.lazydocker
          pkgs.visidata
          pkgs.awscli
          pkgs.ffmpeg
          pkgs.navi
          pkgs.ollama
          pkgs.rbenv
          pkgs.imagemagick
          pkgs.llm
          pkgs.lua
          pkgs.luarocks
          pkgs.tectonic
          pkgs.mongodb-cli
          pkgs.mongosh
          pkgs.age
          pkgs.sqlite-utils
          pkgs.gemini-cli
          pkgs.python313Packages.jupytext
          pkgs.python313Packages.ipython
          pkgs.python313Packages.pip
          pkgs.google-cloud-sdk
          pkgs.rbenv
          pkgs.openssl_3

        ];

    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#MacBook-Pro
    darwinConfigurations."MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
