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
}
