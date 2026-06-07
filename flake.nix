{
  description = "Systems configs";

  inputs = {
    nixpkgs = {url = "github:NixOS/nixpkgs/master";};
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
      url = "github:domwst/rust-overlay/fix/copy-extra-components-on-darwin";
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

    rustToolchain = pkgs:
      pkgs.rust-bin.selectLatestNightlyWith (toolchain:
        toolchain.default.override {
          extensions = ["rust-src" "rustc-dev" "miri" "llvm-tools-preview" "rust-analyzer"];
          targets = ["wasm32-unknown-unknown" "x86_64-unknown-none"];
        });

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
          htop
          just
          jq
          (rustToolchain pkgs)
          clang
          clang-tools
          kubectl
          k9s
          lld
          libllvm
          lldb
          file
          gnumake
          libiconv
          neovim
          tree-sitter
          ninja
          nodejs_24
          python314
          pkg-config
          ripgrep
          rsync
          starship
          tldr
          tree
          tmux
          wget
          zip
          unzip
          yazi
          zoxide
          zellij
          zstd
          openssl
          markdownlint-cli # For neovim
          uv
          opencode
          zig
          qemu
          ghc
          haskell-language-server
          lean4
          resvg
        ];

      desktop = pkgs:
        with pkgs; [
          poppler # PDF rendering
        ];

      macos = pkgs:
        with pkgs; [
          vscode
          aerospace
          colima
          docker-credential-helpers
          iina
        ];
    };

    commonEnv = pkgs: let
      openssl = pkgs.openssl;
      clang = pkgs.clang;
    in {
      CXX = "${clang.outPath}/bin/clang++";
      CC = "${clang.outPath}/bin/clang";
      CRATE_CC_NO_DEFAULTS = "1";
      LIBRARY_PATH = "${pkgs.libiconv}/lib:${builtins.getEnv "LIBRARY_PATH"}";

      PKG_CONFIG_PATH = pkgs.lib.makeSearchPath "lib/pkgconfig" [openssl.dev];
      OPENSSL_NO_VENDOR = "1";
      OPENSSL_DIR = "${openssl.dev}";
      OPENSSL_LIB_DIR = "${openssl.out}/lib";
      OPENSSL_INCLUDE_DIR = "${openssl.dev}/include";
    };

    commonPrograms = pkgs: {
      fish = {
        enable = true;
        interactiveShellInit = builtins.readFile ./fish/config.fish;
      };
      starship.enable = true;
      delta = {
        enable = true;
        enableGitIntegration = true;
      };
      git = {
        settings = {
          push = {
            autoSetupRemote = true;
            default = "current";
          };
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
        "tree-sitter/config.json".source = ./tree-sitter/config.json;
        "fish/conf.d".source = ./fish/conf.d;
        "btop/themes".source = ./btop/themes;
        "zellij/config.kdl".source = ./zellij/config.kdl;

        "opencode/opencode.jsonc".source = ./opencode/opencode.jsonc;
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
        ({pkgs, ...}: {
          nix = {
            settings.trusted-users = ["root" "@admin"];
          };
        })
        home-manager.darwinModules.home-manager
        ({
          pkgs,
          lib,
          ...
        }: {
          system = {
            configurationRevision = self.rev or self.dirtyRev or null;
            stateVersion = 6;
            primaryUser = "oleg";
          };
          nixpkgs = {
            hostPlatform = "aarch64-darwin";
            overlays = [rust-overlay.overlays.default];
            config.allowUnfreePredicate = pkg:
              builtins.elem (lib.getName pkg) [
                "vscode"
              ];
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

          homebrew = {
            enable = true;
            onActivation = {
              autoUpdate = true;
              upgrade = true;
            };
            taps = [];
            casks = ["secretive" "telegram" "raycast" "zed@preview" "zulip" "ghostty" "ollama-app" "zotero"];
            brews = [];
          };
        })
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
      };

      ########################
      # octagon3
      ########################
      "octagon3" = linuxServer {
        target = "x86_64-linux";
        user = "oshatov";
        home = "/home/oshatov";
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
