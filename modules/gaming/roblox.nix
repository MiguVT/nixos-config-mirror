{ ... }:

{
  services.flatpak.packages = [
    "org.vinegarhq.Sober"
    # Nightly build from the latest main branch, not the stable Flathub release.
    # The flatpakref file is a static pointer to the repo, so its hash is stable.
    {
      flatpakref = "https://mocktail.bigrat.space/mocktail.flatpakref";
      sha256 = "03d73538417fc017cd8049b0b6cf68ee40f811c2f5d81a5bd43c9f092bc2a43f";
    }
  ];
}
