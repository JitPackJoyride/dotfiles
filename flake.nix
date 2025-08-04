{
  description = "Ajit's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    platform.url = "/Users/ajit/code/platform";
    home-manager.url = "home-manager";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs@{
    self,
    nix-darwin,
    home-manager,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    ...
  }:
  {
    darwinConfigurations = {
      anterior-bootstrap = nix-darwin.lib.darwinSystem {
        modules = [
          home-manager.darwinModules.home-manager
          inputs.platform.darwinModules.anterior-core
          nix-homebrew.darwinModules.nix-homebrew
          self.darwinModules.homebrew
          self.darwinModules.simple
          self.darwinModules.system
        ];
      };
      simple = nix-darwin.lib.darwinSystem {
        modules = [
          home-manager.darwinModules.home-manager
          inputs.platform.darwinModules.anterior-fancy
          nix-homebrew.darwinModules.nix-homebrew
          self.darwinModules.homebrew
          self.darwinModules.simple
          self.darwinModules.system
        ];
      };
    };
    darwinModules = {
      homebrew = {
        nix-homebrew = {
          enable = true;
          # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
          enableRosetta = true;
          # User owning the Homebrew prefix
          user = "ajit";
          taps = {
            "homebrew/homebrew-core" = homebrew-core;
            "homebrew/homebrew-cask" = homebrew-cask;
          };
          # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
          mutableTaps = false;
        };
      };

      system = { ... }: {
        # Set Git commit hash for darwin-version.
       	system.configurationRevision = self.rev or self.dirtyRev or null;
       	# Used for backwards compatibility, please read the changelog before changing.
       	# $ darwin-rebuild changelog
       	system.stateVersion = 6;
       	# The platform the configuration will be used on.
       	nixpkgs.hostPlatform = "aarch64-darwin";
      };

      simple = { pkgs, ... }: {
        home-manager.users.ajit = self.homeModules.anterior;
        home-manager.users.ajit-work = self.homeModules.anterior;
        home-manager.useUserPackages = true;
        home-manager.useGlobalPkgs = true;

        nixpkgs.config.allowUnfree = true;

        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = [
          pkgs.vim
          pkgs.go
          pkgs.nixd
          pkgs.tmux
          pkgs.awscli2
          pkgs.hello
          pkgs.lazygit
          pkgs.gh
          pkgs.starship
          pkgs.yazi
          pkgs.zoxide
          pkgs.fzf
          pkgs.direnv
          pkgs.bun
          pkgs.bat
        ];

        homebrew = {
          enable = true;
          casks = [
            "raycast"
            "arc"
            "zed"
            "1password"
            "1password-cli"
            "slack"
            "ghostty"
            "claude"
            "orbstack"
            "linear-linear"
            "superhuman"
            "tailscale"
            "postman"
            "notion"
            "notion-calendar"
            "figma"
            "nordvpn"
            "logi-options+"
            "cleanshot"
            "rectangle"
            "visual-studio-code"
            "google-chrome"
          ];
          brews = [
            "libmagic"
            "weasyprint"
          ];
        };
        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Don't rearrange spaces based on the most recent use
        system.defaults.dock.mru-spaces = false;
        system.defaults.dock.autohide = true;

        security.pam.services.sudo_local.touchIdAuth = true;

        system.keyboard = {
          enableKeyMapping = true;
          remapCapsLockToControl = true;
        };

        fonts.packages = [
          pkgs.nerd-fonts.jetbrains-mono
          pkgs.nerd-fonts.fira-code
        ];

        users.knownUsers = [ "ajit" "ajit-work" ];
        users.users.ajit = {
          name = "ajit";
          home = "/Users/ajit";
          uid = 502;
          shell = pkgs.fish;
        };
        users.users.ajit-work = {
          name = "ajit-work";
          home = "/Users/ajit-work";
          uid = 501;
          shell = pkgs.fish;
        };
        programs.fish.enable = true;
        programs.fish.vendor.config.enable = true;
        programs.fish.vendor.completions.enable = true;
        programs.fish.vendor.functions.enable = true;
      };
    };
    homeModules.anterior = ({ ... }:{
      imports = [
        ./home-manager/fish.nix
        ./home-manager/git.nix
        ./home-manager/gh.nix
        ./home-manager/zed-editor.nix
        ./home-manager/starship.nix
        ./home-manager/ghostty.nix
        ./home-manager/yazi.nix
        ./home-manager/zoxide.nix
        ./home-manager/fzf.nix
        ./home-manager/tmux.nix
        ./home-manager/vim.nix
      ];
      home.stateVersion = "24.11";
    });
  };
}
