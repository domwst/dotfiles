{
  description = "Systems configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    rust-overlay,
    ...
  }: let
    overlays = [
      rust-overlay.overlays.default
    ];

    linuxServer = {
      target,
      user,
      home,
      extraModules ? [],
    }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = target;
          inherit overlays;
        };
        modules =
          extraModules
          ++ [
            ./modules/nix.nix
            ./modules/home
            ./modules/home/linux.nix
            {
              home = {
                username = user;
                homeDirectory = home;
              };
            }
          ];
      };
  in {
    ########################
    # Personal laptop
    ########################
    darwinConfigurations.plap = nix-darwin.lib.darwinSystem {
      modules = [
        ./modules/nix.nix
        ./modules/darwin.nix
        home-manager.darwinModules.home-manager
        {
          system.configurationRevision = self.rev or self.dirtyRev or null;
          nixpkgs = {
            hostPlatform = "aarch64-darwin";
            inherit overlays;
          };
          home-manager.users.oleg.imports = [
            ./modules/home
            ./modules/home/desktop.nix
          ];
        }
      ];
    };

    homeConfigurations = {
      ########################
      # Docker image
      ########################
      "docker" = linuxServer {
        target = "aarch64-linux";
        user = "root";
        home = "/root";
      };

      ########################
      # a1
      ########################
      "a1" = linuxServer {
        target = "aarch64-linux";
        user = "oshatov";
        home = "/home/oshatov";
        extraModules = [
          ({...}: {
            home.file.".agents/skills/review-loop".source = ./modules/home/skills/review-loop;
          })
        ];
      };

      ########################
      # octagon3
      ########################
      "octagon3" = linuxServer {
        target = "x86_64-linux";
        user = "oshatov";
        home = "/home/oshatov";
        extraModules = [
          ({...}: {
            home.file.".agents/skills/review-loop".source = ./modules/home/skills/review-loop;
          })
        ];
      };

      ########################
      # htz
      ########################
      "htz" = linuxServer {
        target = "x86_64-linux";
        user = "arch";
        home = "/home/arch";
      };

      ########################
      # YCommunal
      ########################
      "y-communal" = linuxServer {
        target = "x86_64-linux";
        user = "oleg";
        home = "/home/oleg";
      };
    };
  };
}
