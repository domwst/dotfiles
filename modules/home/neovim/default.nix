{pkgs, ...}: {
  home.packages = with pkgs; [
    neovim
    tree-sitter
    markdownlint-cli
    imagemagick # In-terminal Typst previews via Snacks
  ];

  xdg.configFile = {
    "nvim".source = ./nvim;
    "tree-sitter/config.json".source = ./tree-sitter.json;
  };
}
