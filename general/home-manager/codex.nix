{
  config,
  lib,
  pkgs,
  ...
}:

let
  settings = {
    sandbox_mode = "workspace-write";
    approval_policy = "on-request";
    approvals_reviewer = "auto_review";
  };
  python = pkgs.python3.withPackages (ps: [ ps.tomlkit ]);
  configureCodex = pkgs.writeText "configure-codex.py" ''
    import json
    import os
    from pathlib import Path
    import sys
    import tempfile

    import tomlkit

    path = Path(sys.argv[1])
    settings = json.loads(sys.argv[2])
    previous = path.read_text() if path.exists() else ""
    document = tomlkit.parse(previous)
    for key, value in settings.items():
        document[key] = value
    updated = tomlkit.dumps(document)

    if updated != previous:
        path.parent.mkdir(mode=0o700, parents=True, exist_ok=True)
        with tempfile.NamedTemporaryFile(
            mode="w", dir=path.parent, prefix=".config.toml.", delete=False
        ) as temporary:
            temporary.write(updated)
        os.replace(temporary.name, path)
  '';
in
{
  # Keep Codex and its updates managed by the curl installer.
  home.sessionPath = [ "$HOME/.local/bin" ];
  home.packages = [ pkgs.bubblewrap ];

  # Refresh PATH even when inherited Home Manager session variables are stale.
  programs.fish.shellInit = ''
    fish_add_path --path --prepend "$HOME/.local/bin"
  '';

  # Merge only these defaults, preserving other settings and a writable config.
  home.activation.configureCodex = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${python}/bin/python3 ${configureCodex} \
      ${lib.escapeShellArg "${config.home.homeDirectory}/.codex/config.toml"} \
      ${lib.escapeShellArg (builtins.toJSON settings)}
  '';
}
