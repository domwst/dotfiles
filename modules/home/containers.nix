# Containers, Kubernetes and VMs
{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs;
    [
      docker
      docker-compose
      kubectl
      k9s
      qemu
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      colima
      docker-credential-helpers
    ];
}
