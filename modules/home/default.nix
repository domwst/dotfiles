# Features shared by every host
{
  imports = [
    ./base.nix
    ./cli.nix
    ./shell
    ./git.nix
    ./tmux
    ./zellij
    ./btop
    ./neovim
    ./containers.nix
    ./rclone.nix
    ./ai.nix
    ./scripts
    ./dev
  ];
}
