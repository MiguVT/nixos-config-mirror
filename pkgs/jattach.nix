{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "jattach";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "jattach";
    repo = "jattach";
    tag = "v2.2";
    hash = "sha256-xHorLGzTsmU7tHkBRLF8yqx2FlgtNtJg6iYVlXYgRjI=";
  };

  # Single C file, built by the upstream Makefile; there is no install target.
  # The default `all` target is required: it creates build/ before linking.
  installPhase = ''
    runHook preInstall
    install -Dm755 build/jattach $out/bin/jattach
    runHook postInstall
  '';

  meta = {
    description = "JVM diagnostic attach tool (jcmd/jstack/jmap/jinfo without a JDK)";
    homepage = "https://github.com/jattach/jattach";
    license = lib.licenses.asl20;
    mainProgram = "jattach";
    platforms = lib.platforms.unix;
  };
}
