{
  description = "Systems configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

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
    # helper for importing nixpkgs with overlays per system
    pkgsFor = system:
      import nixpkgs {
        inherit system;
        overlays = [rust-overlay.overlays.default];
      };

    profiles = {
      common = pkgs:
        with pkgs; [
          bat
          btop
          cloc
          cmake
          curl
          docker
          docker-compose
          eza
          fd
          ffmpeg
          fzf
          go
          git
          htop
          just
          jq
          (
            rust-bin.selectLatestNightlyWith (toolchain:
              toolchain.default.override {
                extensions = ["rust-src"];
                targets = ["wasm32-unknown-unknown"];
              })
          )
          llvmPackages_20.libcxxClang
          llvmPackages_20.clang-tools
          llvmPackages_20.lld
          gnumake
          libiconv
          neovim
          ninja
          nodejs_24
          python314
          ripgrep
          rsync
          starship
          tldr
          tmux
          wget
          zip
          unzip
          yazi
          zoxide
          zsh
          zstd
        ];

      desktop = pkgs:
        with pkgs; [
          kitty
          poppler # PDF rendering
        ];

      macos = pkgs:
        with pkgs; [
          aerospace
          colima
          docker-credential-helpers
        ];
    };

    commonEnv = pkgs: {
      CXX = "${pkgs.llvmPackages_20.clang}/bin/clang++";
      CC = "${pkgs.llvmPackages_20.clang}/bin/clang";
      CRATE_CC_NO_DEFAULTS = "1";
      LIBRARY_PATH = "${pkgs.libiconv}/lib:${builtins.getEnv "LIBRARY_PATH"}";
    };

    commonPrograms = pkgs: {
      fish = {
        enable = true;
        interactiveShellInit = builtins.readFile ./fish/config.fish;
      };
      starship.enable = true;
      git = {
        delta = {
          enable = true;
        };
        enable = true;
      };
      home-manager.enable = true;
      tmux = (import ./tmux/config.nix) pkgs;
      btop = (import ./btop/config.nix) pkgs;
    };

    nixModule = {pkgs, ...}: {
      nix = {
        settings.experimental-features = ["nix-command" "flakes"];
        package = pkgs.nix;
      };
    };

    xdg = {
      enable = true;
      configFile = {
        "tmux-aux".source = ./tmux/tmux;
        "starship.toml".source = ./starship/starship.toml;
        "nvim".source = ./nvim;
        "fish/conf.d".source = ./fish/conf.d;
        "btop/themes".source = ./btop/themes;
      };
    };

    linuxServer = {
      target,
      user,
      home,
    }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor target;
        modules = [
          nixModule
          ({
            pkgs,
            lib,
            ...
          }: {
            home = {
              username = user;
              homeDirectory = home;
              packages = profiles.common pkgs;
              sessionVariables = commonEnv pkgs;
              stateVersion = "25.05";
              shell.enableFishIntegration = true;
              sessionPath = [
                "/nix/var/nix/profiles/default/bin"
              ];
            };

            targets.genericLinux.enable = true;
            inherit xdg;

            programs = commonPrograms pkgs;
          })
        ];
      };
  in {
    ########################
    # Personal laptop
    ########################
    darwinConfigurations.plap = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit rust-overlay;};
      modules = [
        nixModule
        home-manager.darwinModules.home-manager
        ({
          pkgs,
          lib,
          ...
        }: {
          system = {
            configurationRevision = self.rev or self.dirtyRev or null;
            stateVersion = 6;
          };
          nixpkgs = {
            hostPlatform = "aarch64-darwin";
            overlays = [rust-overlay.overlays.default];
          };

          programs.fish.enable = true;

          users.users.oleg = {
            shell = pkgs.fish;
            name = "oleg";
            home = "/Users/oleg";
          };

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            users.oleg = {pkgs, ...}: {
              home.stateVersion = "25.05";
              inherit xdg;
              programs = commonPrograms pkgs;
            };
          };

          environment = {
            shells = [pkgs.fish];
            systemPackages = profiles.common pkgs ++ profiles.desktop pkgs ++ profiles.macos pkgs;
            variables = commonEnv pkgs;
          };

          security.pam.services.sudo_local.touchIdAuth = true;
          system.primaryUser = "oleg";

          homebrew = {
            enable = true;
            onActivation = {
              autoUpdate = true;
              upgrade = true;
            };
            taps = [];
            casks = ["secretive" "telegram" "raycast" "cursor"];
            brews = [];
          };
        })
      ];
    };

    ########################
    # Docker image
    ########################
    homeConfigurations."docker" = linuxServer {
      target = "aarch64-linux";
      user = "root";
      home = "/root";
    };

    ########################
    # a1
    ########################
    homeConfigurations."a1" = linuxServer {
      target = "aarch64-linux";
      user = "oshatov";
      home = "/home/oshatov";
    };

    ########################
    # octagon3
    ########################
    homeConfigurations."octagon3" = linuxServer {
      target = "x86_64-linux";
      user = "oshatov";
      home = "/home/oshatov";
    };

    ########################
    # htz
    ########################
    homeConfigurations."htz" = linuxServer {
      target = "x86_64-linux";
      user = "arch";
      home = "/home/arch";
    };
  };
}
