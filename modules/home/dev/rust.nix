# Needs rust-overlay applied to pkgs
{pkgs, ...}: {
  home.packages = [
    (pkgs.rust-bin.selectLatestNightlyWith (toolchain:
      toolchain.default.override {
        extensions = ["rust-src" "rustc-dev" "miri" "llvm-tools-preview" "rust-analyzer"];
        targets = ["wasm32-unknown-unknown" "x86_64-unknown-none"];
      }))
  ];

  home.sessionVariables.CRATE_CC_NO_DEFAULTS = "1";
}
