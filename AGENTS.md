# Agent instructions for Anime Nexus

## Automated validation

- Keep automatically triggered checks focused and deterministic.
- The `godot-android` job runs automatically for pushes and pull requests. It builds only the Android arm64 C++ GDExtension and exports the Godot Android APK.
- Do not add Linux-native extension builds or Linux gameplay-runner execution to the automatic workflow. The game target is Android.
- Do not add emulator, device, instrumentation, long-running gameplay, performance, or benchmark tests to automatically triggered workflows.
- Do not add long or redundant tests. Keep rule checks focused; gameplay runner execution remains a separate manual validation.
- APK export success confirms a build artifact only; do not claim device installation, gameplay, or performance validation without observing it.
- Do not claim manual validation passed until the corresponding result has been observed.

## Project boundaries

- Work on `dev/anime-nexus-vertical-slice` and its pull request; never push directly to `main` without explicit authorization.
- Keep the game offline, original, and Android-focused. Never add assets extracted from commercial games.
- C++ is the primary language for authoritative gameplay rules. Use Godot/GDScript for engine integration and presentation only where appropriate.
