{pkgs, ...}: {
  home.packages = with pkgs; [
    bat
    cloc
    curl
    eza
    fd
    ffmpeg
    file
    fzf
    htop
    jq
    just
    resvg
    ripgrep
    rsync
    tldr
    tree
    typst
    unzip
    wget
    yazi
    zip
    zoxide
    zstd
  ];
}
