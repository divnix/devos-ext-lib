{
  inputs,
  cell,
}: {
  # based on https://www.creeperhost.net/wiki/books/minecraft-java-edition/page/changing-java-versions
  jreMcVersion = version: let
    jre =
      {
        "1.17" = ["jre8"];
        "1.18" = ["adoptopenjdk-jre-openj9-bin-16"];
        "1.19" = ["javaPackages" "compiler" "openjdk17" "headless"];
      }
      .${version}
      or ["jre_headless"];
  in
    jre;
}
