{
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = builtins.readFile ./config.fish;
    };
    starship.enable = true;
  };

  home.shell.enableFishIntegration = true;

  xdg.configFile = {
    "fish/conf.d".source = ./conf.d;
    "starship.toml".source = ./starship.toml;
  };
}
