{ pkgs, lib, ... }:

let
  python_sys = pkgs.python312;
in
{
  home.packages = [
    # Python
    python_sys
    # Node.js
    pkgs.nodejs_latest
    #jdk21
    pkgs.jdk21
    #maven
    pkgs.maven
    #gradle
    pkgs.gradle
    # php83
    # (pkgs.php83.buildEnv {
    #   extensions = (
    #     { enabled, all }:
    #     enabled
    #     ++ (with all; [
    #       xdebug
    #     ])
    #   );
    #   extraConfig = ''
    #     xdebug.mode=debug
    #     xdebug.start_with_request=yes
    #   '';
    # })
    # #composer php83
    # pkgs.php83Packages.composer
    # pkgs.php83Packages.php-cs-fixer
    pkgs.nest-cli
  ];

  home.sessionVariables = {
    # Python
    PYTHONSTARTUP = "${python_sys}/lib/python3.12/site-packages";

    # Node.js
    NODE_PATH = "~/.npm-global/lib/node_modules";

    # Java 21
    JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";

    # Gradle home
    GRADLE_HOME = "${pkgs.gradle}/lib/gradle";

    # Maven home
    MVN_HOME = "${pkgs.maven}/maven";
  };
}
