{pkgs}:
with pkgs; [
  (writeShellApplication {
    name = "upload";
    text = builtins.readFile ./upload.sh;

    runtimeInputs = [curl jq];
  })
  (writeShellApplication {
    name = "ccopy";
    text = builtins.readFile ./ccopy.sh;
    runtimeInputs = [basez];
  })
]
