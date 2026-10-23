{pkgs, ...}: {
  home.packages = with pkgs; [
    clang
    clang-tools
    cmake
    gnumake
    libiconv
    libllvm
    lld
    lldb
    ninja
    pkg-config
  ];

  home.sessionVariables = {
    CC = "${pkgs.clang}/bin/clang";
    CXX = "${pkgs.clang}/bin/clang++";
  };

  # Prepended to the inherited value at shell startup, no trailing `:` when unset
  home.sessionSearchVariables.LIBRARY_PATH = ["${pkgs.libiconv}/lib"];
}
