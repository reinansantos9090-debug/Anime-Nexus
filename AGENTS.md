# Agent instructions for Anime Nexus

## Automated validation

- Keep push and pull request checks short, deterministic, and headless.
- Do not add Android emulator, device, instrumentation, long-running integration, performance, or benchmark tests to automatically triggered workflows.
- Do not add long or redundant tests to the repository. Prefer focused tests for gameplay rules and persistence.
- When a necessary validation is slow, put it in a job that runs only on `workflow_dispatch`. Do not run it automatically on push or pull request.
- Native Godot C++ cross-compilation and Godot Android APK export take a long time. Keep the `godot-android` job manual-only; a successful result is not implied by the automatic Kotlin job.
- Do not claim manual validation passed until a user has dispatched it and the result has been observed.

## Project boundaries

- Work on `dev/anime-nexus-vertical-slice` and its pull request; never push directly to `main` without explicit authorization.
- Keep the game offline, original, and Android-focused. Never add assets extracted from commercial games.
- C++ is the primary language for authoritative gameplay rules. Use Godot/GDScript for engine integration and presentation only where appropriate.
