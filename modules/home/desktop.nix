# Hosts with a graphical session
{pkgs, ...}: {
  home.packages = with pkgs; [
    poppler # PDF rendering
  ];
}
