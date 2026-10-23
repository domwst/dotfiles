{pkgs, ...}: {
  home.packages = with pkgs; [
    jdk25
    flix
  ];

  home.sessionVariables.JAVA_HOME = "${pkgs.jdk25.home}";
}
