{
  config,
  lib,
  pkgs,
  ...
}: let
  settings = {
    sandbox_mode = "workspace-write";
    approval_policy = "on-request";
    approvals_reviewer = "auto_review";
    mcp_servers.codegraph = {
      command = "${config.home.homeDirectory}/.local/bin/codegraph";
      args = ["serve" "--mcp"];
      enabled = true;
      startup_timeout_sec = 20;
    };
  };
  python = pkgs.python3.withPackages (ps: [ps.tomlkit]);
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
    def merge_settings(target, settings):
        for key, value in settings.items():
            if isinstance(value, dict):
                if key not in target or not isinstance(target[key], dict):
                    target[key] = tomlkit.table()
                merge_settings(target[key], value)
            else:
                target[key] = value

    merge_settings(document, settings)
    updated = tomlkit.dumps(document)

    if updated != previous:
        path.parent.mkdir(mode=0o700, parents=True, exist_ok=True)
        with tempfile.NamedTemporaryFile(
            mode="w", dir=path.parent, prefix=".config.toml.", delete=False
        ) as temporary:
            temporary.write(updated)
        os.replace(temporary.name, path)
  '';
in {
  # Keep Codex and its updates managed by the curl installer.
  home.sessionPath = ["$HOME/.local/bin"];
  home.packages = [pkgs.bubblewrap];

  # Refresh PATH even when inherited Home Manager session variables are stale.
  programs.fish.shellInit = ''
    fish_add_path --path --prepend "$HOME/.local/bin"
  '';

  # Keep navigation guidance short; the MCP server supplies the detailed usage guide.
  home.file.".codex/AGENTS.md".text = ''
    <!-- CODEGRAPH_START -->
    ## CodeGraph

    For repositories with a CodeGraph index (.codegraph/codegraph.db), prefer codegraph_explore for locating symbols, tracing calls, and understanding change impact. Start with a focused query and maxFiles=3; request more context only when needed.
    If MCP is unavailable, use codegraph explore "<symbol or question>" --max-files 3 in the repository. Use rg and direct reads for literal text, configuration, documentation, missing graph relationships, or stale results. Validate changes with the project's checks.
    <!-- CODEGRAPH_END -->
  '';

  # Merge only these defaults, preserving other settings and a writable config.
  home.activation.configureCodex = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run ${python}/bin/python3 ${configureCodex} \
      ${lib.escapeShellArg "${config.home.homeDirectory}/.codex/config.toml"} \
      ${lib.escapeShellArg (builtins.toJSON settings)}
  '';
}
