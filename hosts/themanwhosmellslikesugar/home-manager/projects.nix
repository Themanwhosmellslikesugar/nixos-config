{
  config,
  pkgs,
  lib,
  ...
}:
let
  projectsDir = "${config.home.homeDirectory}/Projects";
in
{
  home.activation.kubeconfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    install -Dm600 /run/agenix/kubeconfig "/home/themanwhosmellslikesugar/.kube/config"
  '';

  home.activation.cloneRepos = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${projectsDir}
    export PATH=${pkgs.openssh}/bin:${pkgs.git}/bin:$PATH

    if [ ! -d "${projectsDir}/radius/platform-boards" ]; then
      ${pkgs.git}/bin/git clone git@gitlab-yc.myradius.ru:myradius/backend/platform-boards.git ${projectsDir}/radius/platform-boards
    fi

    if [ ! -d "${projectsDir}/radius/platform-survey" ]; then
      ${pkgs.git}/bin/git clone git@gitlab-yc.myradius.ru:myradius/backend/platform-survey.git ${projectsDir}/radius/platform-survey
    fi

    if [ ! -d "${projectsDir}/cusdeb/hammett" ]; then
      ${pkgs.git}/bin/git clone git@github.com:cusdeb-com/hammett.git ${projectsDir}/cusdeb/hammett
    fi
  '';

  home.file."Projects/radius/platform-boards/.zed/settings.json".text = ''
    {
      "languages": {
        "Elixir": { "format_on_save": "off" },
        "YAML": { "format_on_save": "off" }
      },
      "wrap_guides": [100],
      "terminal": {
        "env": {
          "RABBITMQ_QUEUE_SURVEY_RATING": "survey_ratings_queue",
          "RABBITMQ_USER": "guest",
          "RABBITMQ_PASSWORD": "guest",
          "RABBITMQ_HOST": "localhost"
        }
      }
    }
  '';

  home.file."Projects/radius/platform-boards/.zed/tasks.json".text = ''
    [
      {
        "label": "mix phx.server",
        "command": "mix phx.server",
        "reveal": "always",
        "env": {
          "RABBITMQ_QUEUE_SURVEY_RATING": "survey_ratings_queue",
          "RABBITMQ_USER": "guest",
          "RABBITMQ_PASSWORD": "guest",
          "RABBITMQ_HOST": "localhost"
        }
      },
      {
        "label": "dbg phx.server",
        "command": "iex -S mix phx.server",
        "reveal": "always"
      },
      {
        "label": "tests",
        "command": "mix test",
        "env": { "TESTING": "true" },
        "use_new_terminal": false,
        "allow_concurrent_runs": false,
        "reveal": "always",
        "hide": "never",
        "shell": "system",
        "show_summary": true,
        "show_output": true,
        "tags": []
      }
    ]
  '';

  home.file."Projects/radius/platform-survey/.zed/tasks.json".text = ''
    // Static tasks configuration.
    //
    // Example:
    [
      {
        "label": "celery",
        "command": "celery",
        "args": [
          "-A",
          "src.worker.celery_app",
          "worker",
          // "-B",
          "-Q",
          "survey_process_companies_queue,survey_process_general_function_queue,survey_process_companies_send_questions_queue,survey_send_questions_to_company_queue",
          // "survey_ratings_queue",
          "-l",
          "INFO",
          "--concurrency",
          "2"
        ],
        "use_new_terminal": false,
        "allow_concurrent_runs": false,
        "reveal": "always"
      },
      {
        "label": "call global task",
        "command": "celery",
        "args": [
          "-A",
          "src.worker.celery_app",
          "call",
          "--queue",
          "survey_process_companies_queue",
          "src.worker.tasks.general.start_process_companies"
        ],
        "use_new_terminal": false,
        "allow_concurrent_runs": false,
        "reveal": "always"
      },
      {
        "label": "call function task",
        "command": "celery",
        "args": [
          "-A",
          "src.worker.celery_app",
          "call",
          "--queue",
          "survey_process_general_function_queue",
          "src.worker.tasks.general.process_function",
          "--args",
          "'[676]'"
        ],
        "use_new_terminal": false,
        "allow_concurrent_runs": false,
        "reveal": "always"
      },
      {
        "label": "call send global task",
        "command": "celery",
        "args": [
          "-A",
          "src.worker.celery_app",
          "call",
          "--queue",
          "survey_send_questions_to_company_queue",
          "src.worker.tasks.general.start_process_companies_send_questions"
        ],
        "use_new_terminal": false,
        "allow_concurrent_runs": false,
        "reveal": "always"
      },
      {
        "label": "server",
        "command": "python3 main.py",
        "reveal": "always"
      }
    ]
  '';

  home.file."Projects/radius/platform-survey/.zed/settings.json".text = ''
    {
      "lsp": {
        "pyright": {
          "settings": {
            "python.analysis": {
              "diagnosticMode": "workspace",
              "typeCheckingMode": "strict",
              "ignore": ["test.py", "test_req.py"]
            },
            "python": {
              "pythonPath": "/home/themanwhosmellslikesugar/Projects/radius/platform-survey/.venv/bin/python"
            }
          }
        }
      },
      "terminal": {
        "detect_venv": {
          "on": {
            "directories": ["$ZED_WORKTREE_ROOT/.venv", ".venv", "venv"],
            "activate_script": "default"
          }
        }
      },
      "languages": {
        "Python": {
          "language_servers": ["pyright", "ruff"],
          "format_on_save": "on",
          "formatter": [
            {
              "code_actions": {
                "source.fixAll.ruff": true,
                "source.organizeImports.ruff": true
              }
            }
          ]
        }
      },
      "wrap_guides": [100]
    }
  '';
}
