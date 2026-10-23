{pkgs, ...}: {
  home.packages = [
    (pkgs.lean4.overrideAttrs (old: {
      preConfigure =
        (old.preConfigure or "")
        + ''
          cmakeFlagsArray+=("-DSTAGE1_CMAKE_INSTALL_PREFIX=$out")
        '';
    }))
  ];
}
