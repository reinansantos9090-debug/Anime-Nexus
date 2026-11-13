# Anime Nexus — protótipo Godot

Godot 4.7.2 stable is the target runtime for the first vertical slice. The Android export uses landscape orientation and a separate Anime Nexus application ID.

The project is intentionally source/configuration based. Godot editor binaries and generated .godot data are not committed.

Current slice work:
- Kaien loadout with Manoplas Fulgor and three active electrical abilities.
- First Nimbara mission, three-phase Cérvido de Cristal boss flow, and a proximity interaction for the Resonance Anchor.
- Orthographic isometric follow camera, mobile analog joystick and limited slice HUD.
- Procedural blockout geometry for Kaien, forest, creatures, boss and anchor; these are not final art assets.
- Separate local save file for Anime Nexus; it does not read the old Aetheria save.
- Headless rules tests and Android export workflow.

The Kotlin/OpenGL implementation remains as an audited legacy prototype. Its current CI compile has unresolved source errors; see `../docs/IMPLEMENTATION_STATUS.md`.

This project remains an early prototype. The rest of the campaign, final 3D models/rigs, full maps, companion AI, expanded saves, audio, measured performance and on-device validation are not implemented.
