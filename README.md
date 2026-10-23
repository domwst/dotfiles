# Configs that I've yanked from the internet and they somehow work for me

## Setup

```sh
home-manager switch --flake .#<flake>
# macOS
sudo darwin-rebuild switch --flake .#plap
```

Or simply copy appropriate configutation files manually.

## Layout

- `flake.nix` — hosts: platform, user and the list of modules each one imports
- `modules/home/` — home-manager modules, one per feature (its packages, env vars and config files together); `default.nix` is the set every host gets. Modules that ship config files are directories, with the files next to their `default.nix`
- `modules/home/dev/` — language toolchains
- `modules/darwin.nix` — macOS system-level bits (Homebrew, Touch ID, GUI apps)
