# Indian Monsoon Rescue

A Godot 4 prototype for an Android-first low-poly 3D rescue game set in a fictional Indian village during monsoon floods.

## Current prototype
- Procedural 3D scene and flood-water environment
- Boat movement and keyboard/touch-oriented controls (depending on implementation in `monsoon_rescue.gd`)
- Rescue objective, score, countdown timer and end screen

## Open in Godot
1. Install Godot 4.x.
2. Download or clone this repository.
3. Open the folder containing `project.godot` in Godot Project Manager.
4. Let Godot import the project, then press **F6** to run the main scene or **F5** to run the project.

## Android export
Install the matching Godot export templates, Android SDK and JDK. Configure Android SDK/JDK paths in Editor Settings, install the Android export template, then add an Android export preset and set package ID, version and signing details before exporting an APK/AAB.

## Notes
This is an early prototype, not a release-ready game. Test on desktop first, then validate touch controls, performance and Android export on a real device.
