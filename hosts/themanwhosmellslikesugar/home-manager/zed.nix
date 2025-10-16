{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "python"
      "dockerfile"
      "yaml"
      "toml"
      "elixir"
      "sql"
    ];
    userSettings = {
      telemetry = {
        metrics = false;
      };
      theme = {
        mode = "system";
        light = "One Light";
        dark = "One Dark";
      };

      ui_font_size = 14;
      buffer_font_size = 14;

      wrap_guides = [ 100 ];

      load_direnv = "shell_hook";
      languages = {
        "Python" = {
          "language_servers" = [ "ty" "ruff" ];
        };
        "Elixir" = {
          language_servers = [
            "!lexical"
            "elixir-ls"
          ];
          show_edit_predictions = true;
          format_on_save = "off";
        };
        "HEEX" = {
          language_servers = [
            "!lexical"
            "elixir-ls"
          ];
          format_on_save = "off";
        };
      };

      lsp = {
        "lexical" = {
          enable_lsp_tasks = true;
        };
        "ty" = {
          binary = {
            path = "${pkgs.ty}/bin/ty";
            arguments = ["server"];
          };
        };
        "ruff" = {
          binary = {
            path = "${pkgs.ruff}/bin/ruff";
            arguments = ["server"];
          };
        };
      };

      file_scan_exclusions = [
        "_build"
        ".vscode"
        ".lexical"
        ".elixir_ls"
        ".coverage"
        ".venv"
        ".pytest_cache/"
        ".mypy_cache/"
        ".ruff_cache"
        ".git/"
        ".idea"
        "**/__pycache__"
        "node_modules"
        "test_db.sql"
        ".ropeproject"
      ];
    };

    userKeymaps = [
      {
        context = "Editor";
        bindings = {
          "ctrl-right" = [
            "editor::MoveToEndOfLine"
            { "stop_at_soft_wraps" = true; }
          ];
          "ctrl-left" = [
            "editor::MoveToBeginningOfLine"
            {
              "stop_at_soft_wraps" = true;
              "stop_at_indent" = true;
            }
          ];
          "ctrl-shift-alt-s" = [
            "editor::SortLinesCaseSensitive"
            { }
          ];
          "ctrl-shift-alt-i" = [
            "editor::SortLinesCaseInsensitive"
            { }
          ];
        };
      }
    ];
  };
}
