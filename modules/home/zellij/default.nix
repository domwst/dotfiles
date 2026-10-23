{pkgs, ...}: {
  home.packages = [pkgs.zellij];

  xdg.configFile = {
    "zellij/config.kdl".source = ./config.kdl;
    "zellij/plugins/vim-zellij-navigator.wasm".source = pkgs.fetchurl {
      url = "https://github.com/hiasr/vim-zellij-navigator/releases/download/0.3.0/vim-zellij-navigator.wasm";
      hash = "sha256-d+Wi9i98GmmMryV0ST1ddVh+D9h3z7o0xIyvcxwkxY0=";
    };
  };
}
