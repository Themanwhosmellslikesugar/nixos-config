{ ... }:
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
          "language_servers" = [ "pyright" ];
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
      {
        "context" = "(Workspace && keyboard_layout == Russian) > Pane > Editor";
        "bindings" = {
          "ctrl-cyrillic_es" = "editor::Copy";
          "ctrl-cyrillic_em" = "editor::Paste";
          "ctrl-cyrillic_che" = "editor::Cut";
          "ctrl-cyrillic_ef" = "editor::SelectAll";
          "ctrl-cyrillic_ya" = "editor::Undo";
          "ctrl-shift-cyrillic_ya" = "editor::Redo";
          "ctrl-cyrillic_en" = "editor::Redo";
          "ctrl-cyrillic_a" = "buffer_search::Deploy";
          "ctrl-ukrainian_i" = "workspace::Save";
          "ctrl-." = "editor::ToggleComments";
        };
      }
    ];
  };
}
