{
  description = "Ajit's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
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
      main = nix-darwin.lib.darwinSystem {
        modules = [
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
          self.darwinModules.homebrew
          self.darwinModules.main
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
       	# Used for backwards compatibility, please read the changelog before changing.
       	# $ darwin-rebuild changelog
       	system.stateVersion = 6;
       	# The platform the configuration will be used on.
       	nixpkgs.hostPlatform = "aarch64-darwin";
      };

      main = { pkgs, ... }: {
        # Set Git commit hash for darwin-version.
       	system.configurationRevision = self.rev or self.dirtyRev or null;

        home-manager.users.ajit = self.homeModules.main;
        home-manager.useUserPackages = true;
        home-manager.useGlobalPkgs = true;

        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = [
          pkgs.vim
          pkgs.nixd
          pkgs.tmux
          pkgs.awscli2
          pkgs.lazygit
          pkgs.gh
          pkgs.starship
          pkgs.yazi
          pkgs.zoxide
          pkgs.fzf
          pkgs.bat
          pkgs.jujutsu
          pkgs.raycast
          pkgs._1password-gui
          pkgs._1password-cli
          pkgs.slack
          pkgs.orbstack
          pkgs.notion-app
          pkgs.rectangle
        ];

        homebrew = {
          enable = true;
          casks = [
            "arc"
            "ghostty"
            "linear-linear"
            "superhuman"
            "notion-calendar"
            "figma"
            "cleanshot"
            "paste"
          ];
        };

        nix = {
          package = pkgs.nix;
          gc.automatic = true;
          optimise.automatic = true;
          settings = {
            # Necessary for using flakes on this system.
            experimental-features = [ "nix-command" "flakes" ];
          };
        };
        nixpkgs.config.allowUnfree = true;


        security.pam.services.sudo_local.touchIdAuth = true;
        security.pam.services.sudo_local.watchIdAuth = true;

        users.knownUsers = [ "ajit" ];
        users.users.ajit = {
          name = "ajit";
          home = "/Users/ajit";
          uid = 501;
          shell = pkgs.fish;
        };
        system.primaryUser = "ajit";

        # Keyboard
        system.keyboard = {
          enableKeyMapping = true;
          remapCapsLockToControl = true;
        };
        system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
        system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
        system.defaults.CustomUserPreferences = {
          "com.apple.symbolichotkeys" = {
            AppleSymbolicHotKeys = {
              "64" = { enabled = false; };  # Spotlight search
              "65" = { enabled = false; };  # Finder search window
            };
          };
        };

        # Default web browser
        system.defaults.CustomUserPreferences = {
          "com.apple.LaunchServices/com.apple.launchservices.secure" = {
            LSHandlers = [
              {
                LSHandlerRoleAll = "company.thebrowser.browser";
                LSHandlerURLScheme = "http";
              }
              {
                LSHandlerRoleAll = "company.thebrowser.browser";
                LSHandlerURLScheme = "https";
              }
            ];
          };
        };

        # Dock
        system.defaults.dock.persistent-apps = [
          "/Applications/Arc.app"
          "/Applications/Ghostty.app"
          "/Applications/Nix Apps/Slack.app"
          "/Users/ajit/Applications/Home Manager Apps/Zed.app"
          "/System/Applications/Music.app"
          "/Applications/Nix Apps/Notion.app"
          "/Applications/Notion Calendar.app"
          "/Applications/Superhuman.app"
          "/Applications/Linear.app"
          "/Applications/Circleback.app"
        ];
        system.defaults.dock.show-recents = false;
        # Don't rearrange spaces based on the most recent use
        system.defaults.dock.mru-spaces = false;
        system.defaults.dock.autohide = true;

        # Appearance
        system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
        system.defaults.NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = false;

        fonts.packages = [
          pkgs.nerd-fonts.jetbrains-mono
          pkgs.nerd-fonts.fira-code
        ];

        programs.fish.enable = true;
        programs.fish.vendor.config.enable = true;
        programs.fish.vendor.completions.enable = true;
        programs.fish.vendor.functions.enable = true;
      };
    };
    homeModules.main = ({ ... }:{
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
      home.stateVersion = "25.11";
    });
  };
}
