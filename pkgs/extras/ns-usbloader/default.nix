{ lib
, copyDesktopItems
, makeWrapper
, fetchFromGitHub
, maven
, makeDesktopItem
, jre
, openjdk
}:

let
  pkgDescription = "All-in-one tool for Nintendo Switch homebrew";

  desktopItem = makeDesktopItem {
    type = "Application";
    name = "ns-usbloader";
    desktopName = "NS-USBLoader";
    comment = pkgDescription;
    exec = "ns-usbloader";
    icon = "ns-usbloader";
    categories = [ "Game" ];
    terminal = false;
    keywords = [ "nintendo" "switch" "loader" ];
  };

  jreWithJavaFX = jre.override { enableJavaFX = true; };
in
maven.buildMavenPackage rec {
  pname = "ns-usbloader";
  version = "7.0";

  src = fetchFromGitHub {
    owner = "developersu";
    repo = "ns-usbloader";
    rev = "v${version}";
    sha256 = "sha256-x4zGwsDUVUHI4AUMPSqgnZVyZx+pWQA5xvtrFE8U3QU=";
  };

  patches = [ ./no-launch4j.patch ./make-deterministic.patch ];

  mvnParameters = "-DskipTests";
  mvnHash = "sha256-vXZAlZOh9pXNF1RL78oQRal5pkXFRKDz/7SP9LibgiA=";

  nativeBuildInputs = [
    copyDesktopItems
    maven
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    install -Dm644 target/ns-usbloader-${version}.jar $out/share/java/ns-usbloader.jar

    mkdir -p $out/bin
    makeWrapper ${jreWithJavaFX}/bin/java $out/bin/ns-usbloader \
      --append-flags "-jar $out/share/java/ns-usbloader.jar"

    mkdir -p $out/lib/udev/rules.d
    install -Dm644 ${./99-ns-usbloader.rules} $out/lib/udev/rules.d/99-ns-usbloader.rules

    mkdir -p $out/share/icons/hicolor
    install -Dm644 target/classes/res/app_icon32x32.png $out/share/icons/hicolor/32x32/apps/ns-usbloader.png
    install -Dm644 target/classes/res/app_icon48x48.png $out/share/icons/hicolor/48x48/apps/ns-usbloader.png
    install -Dm644 target/classes/res/app_icon64x64.png $out/share/icons/hicolor/64x64/apps/ns-usbloader.png
    install -Dm644 target/classes/res/app_icon128x128.png $out/share/icons/hicolor/128x128/apps/ns-usbloader.png

    runHook postInstall
  '';

  desktopItems = [ desktopItem ];

  meta = with lib; {
    description = pkgDescription;
    homepage = "https://github.com/developersu/ns-usbloader";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ imsofi ];
    platforms = openjdk.meta.platforms;
  };
}
