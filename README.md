# Indian Monsoon Rescue

A lightweight Godot 4 low-poly 3D rescue prototype designed for Android phones. The PC is only the development environment; the intended player controls are on-screen touch buttons.

## Project files

- `project.godot` — Godot project settings and main-scene entry point.
- `main.tscn` — scene root that loads `monsoon_rescue.gd`.
- `monsoon_rescue.gd` — procedural village, water, rescue boat, villagers, HUD, timer, touch controls, pause and restart logic.
- `export_presets.cfg` — starter Android export preset. It still needs a valid local SDK/JDK and signing configuration.
- `CONTROLS.md` — control reference and device test checklist.
- `ANDROID_BUILD.md` — Android setup and APK validation steps.

## Open and run

1. Install a compatible Godot 4.x **standard** editor build.
2. In Godot Project Manager choose **Import** and select this folder's `project.godot`.
3. Open the project and press **F6** to run the main scene or **F5** to run the project.
4. Desktop keyboard input is available for development; on Android use the on-screen buttons.

## Android APK

1. Install matching Godot export templates from the editor's version.
2. Install Android SDK command-line tools/platform tools and a supported JDK.
3. In Godot Editor Settings configure the Android SDK path and Java SDK path.
4. Open **Project > Export**, select the Android preset, and verify the unique package name, version, orientation and architecture options.
5. Configure a release keystore only when preparing a release. Never commit private keystore files or passwords.
6. Export a debug APK, install it on a real phone, and test the touch layout, rescue loop, pause/resume, restart and performance.

## Current limitations

This is an early procedural prototype, not a finished or device-verified release. Villagers are counted as rescued when the boat approaches them; there is not yet a return-to-shelter/drop-off mission flow, persistent save data, audio, rain simulation or polished main menu. The Android preset is a starting configuration, not proof that an APK can already be exported. The game has not been verified on a physical Android device.
