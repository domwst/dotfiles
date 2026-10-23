# Valid as both a nix-darwin and a home-manager module
{pkgs, ...}: {
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    package = pkgs.nix;
  };
}
