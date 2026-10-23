{pkgs, ...}: let
  inherit (pkgs) openssl;
in {
  home.packages = [openssl];

  home.sessionVariables = {
    OPENSSL_NO_VENDOR = "1";
    OPENSSL_DIR = "${openssl.dev}";
    OPENSSL_LIB_DIR = "${openssl.out}/lib";
    OPENSSL_INCLUDE_DIR = "${openssl.dev}/include";
  };

  home.sessionSearchVariables.PKG_CONFIG_PATH = ["${openssl.dev}/lib/pkgconfig"];
}
