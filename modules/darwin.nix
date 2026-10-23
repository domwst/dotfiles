{
  pkgs,
  lib,
  ...
}: {
  nix.settings.trusted-users = ["root" "@admin"];

  system = {
    stateVersion = 6;
    primaryUser = "oleg";
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "vscode"
    ];

  programs.fish.enable = true;
  # https://github.com/nix-darwin/nix-darwin/pull/1818
  documentation.doc.enable = false;
  system.tools.darwin-uninstaller.enable = false;

  users.users.oleg = {
    shell = pkgs.fish;
    name = "oleg";
    home = "/Users/oleg";
  };

  # Everything user-facing lives in home-manager modules, see ./home
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  environment = {
    shells = [pkgs.fish];
    # GUI apps stay system-wide so they get linked into /Applications/Nix Apps
    systemPackages = with pkgs; [
      aerospace
      iina
      stats
    ];
    systemPath = lib.mkAfter [
      "/opt/homebrew/bin"
      "/opt/homebrew/sbin"
    ];
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
}
