# Non-NixOS Linux hosts running standalone home-manager
{pkgs, ...}: {
  targets.genericLinux.enable = true;

  home = {
    packages = [pkgs.bubblewrap];
    sessionPath = [
      "/nix/var/nix/profiles/default/bin"
    ];
  };
}
