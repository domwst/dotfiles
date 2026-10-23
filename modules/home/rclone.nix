{pkgs, ...}: {
  home.packages = [pkgs.rclone];

  home.sessionVariables = {
    RCLONE_CONFIG = "/dev/null";
    RCLONE_CONFIG_YD_TYPE = "yandex";
  };
}
