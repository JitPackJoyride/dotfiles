{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/a6746213b138fe7add88b19bafacd446de574ca7";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    platform.url = "/Users/ajit/code/platform";
    home-manager.url = "home-manager";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, platform, home-manager }:
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."simple" = nix-darwin.lib.darwinSystem {
      modules = [ 
        home-manager.darwinModules.home-manager
        platform.darwinModules.anterior-fancy 
        self.darwinModules.simple 
        ({...}:{
	      # Set Git commit hash for darwin-version.
	      system.configurationRevision = self.rev or self.dirtyRev or null;

	      # Used for backwards compatibility, please read the changelog before changing.
	      # $ darwin-rebuild changelog
	      system.stateVersion = 6;

	      # The platform the configuration will be used on.
	      nixpkgs.hostPlatform = "aarch64-darwin";
        })
      ];
    };
    darwinModules.simple = { pkgs, ... }: {
      home-manager.users.ajit = self.homeModules.anterior;
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim pkgs.hello
        ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;
      
      users.users.ajit = {
        name = "ajit";
        home = "/Users/ajit";
        uid = 501;
      };
      users.knownUsers = [ "ajit" ];
    };
    homeModules.anterior = ({...}:{
      home.stateVersion = "24.11";
      programs.git = {
        enable = true;
        userName = "Ajit Krishna";
        userEmail = "ajit@anterior.com";
      };
    });
  };
}
