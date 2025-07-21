{
  config,
  pkgs,
  lib,
  ...
}:
let
  projectsDir = "${config.home.homeDirectory}/Projects";
  documentsDir = "${config.home.homeDirectory}/Documents";

  korallmicroProjects = [
      "dracula"
  ];

  cusdebProjects = [
    "hammett"
  ];

  tntProjects = [
    "tutorin.tech"
  ];

  radiusProjects = [
    "backend/platform-boards"
    "backend/platform-survey"
    "backend/platform-middleware"
    "backend/platform-authorization"
    "backend/platform-realtime-ms"
    "backend/platform-matrix"
    "app-chart"
  ];

  infraRadiusProjects = [
    "pipeline"
  ];

  genGitCloneCmd = repoInfo: ''
    if [ ! -d "${repoInfo.dest}" ]; then
      ${pkgs.git}/bin/git clone ${repoInfo.url} ${repoInfo.dest}
    fi
  '';

  repos =
    (map (name: {
      dest = "${projectsDir}/korallmicro/${name}";
      url = "git@github.com:CusDeb-Solutions/${name}.git";
    }) korallmicroProjects) ++

    (map (name: {
      dest = "${projectsDir}/cusdeb/${name}";
      url = "git@github.com:cusdeb-com/${name}.git";
    }) cusdebProjects) ++

    (map (name: {
      dest = "${projectsDir}/cusdeb/${name}";
      url = "git@github.com:tutorin-tech/${name}.git";
    }) tntProjects) ++

    (map (name: {
      dest = "${projectsDir}/radius/${lib.last (lib.splitString "/" name)}";
      url = "git@gitlab-yc.myradius.ru:myradius/${name}.git";
    }) radiusProjects) ++

    (map (name: {
      dest = "${projectsDir}/radius/${name}";
      url = "git@gitlab-yc.myradius.ru:infra/${name}.git";
    }) infraRadiusProjects);
in
{
  home.activation.cloneRepos = lib.hm.dag.entryAfter [ "writeBoundary" ] (''
    mkdir -p ${projectsDir} ${documentsDir}
    export PATH=${pkgs.openssh}/bin:${pkgs.git}/bin:$PATH

    if [ ! -d "${documentsDir}/mind-db" ]; then
      ${pkgs.git}/bin/git clone git@github.com:Themanwhosmellslikesugar/mind-db.git ${documentsDir}/mind-db
    fi
  '' + lib.concatStringsSep "\n" (map genGitCloneCmd repos));

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
