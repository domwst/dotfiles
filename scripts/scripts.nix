{pkgs}: [
  (pkgs.writeShellApplication {
    name = "upload";
    text = builtins.readFile ./upload.sh;

    runtimeInputs = with pkgs; [curl jq];
  })
]
