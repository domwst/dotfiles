{pkgs, ...}: {
  home.packages = with pkgs; [
    gh
    glab
  ];

  programs = {
    git = {
      enable = true;
      settings.push = {
        autoSetupRemote = true;
        default = "current";
      };
    };
    delta = {
      enable = true;
      enableGitIntegration = true;
    };
  };
}
