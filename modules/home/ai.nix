{pkgs, ...}: {
  imports = [./skills];

  home.packages = with pkgs; [
    codex
    opencode
  ];
}
