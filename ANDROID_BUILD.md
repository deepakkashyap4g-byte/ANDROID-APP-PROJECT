# Android build and APK checklist

This project targets Android phones in landscape orientation. The PC is only used to edit and export the game.

## Requirements
- Godot 4.3 or a compatible Godot 4.x standard editor.
- Matching Godot export templates installed from Editor > Manage Export Templates.
- Android SDK command-line tools and platform-tools.
- A supported JDK configured in Editor Settings > Export > Android.
- USB debugging enabled on the test phone (optional if transferring the APK manually).

## Export
1. Open `project.godot` in Godot.
2. Let the editor import the project, then run with F6 and check the Output panel for script errors.
3. Open Project > Export and select Android.
4. Configure the Android SDK and Java SDK paths in Editor Settings.
5. Export a debug APK to a local build folder outside the source tree.
6. Install on a phone and test movement, steering, rescue counter, timer, pause and restart in landscape.

## Before publishing
- Set a real unique reverse-DNS package ID instead of the sample `com.example` identifier.
- Set app version and icon.
- Create and safely store a release keystore. Never commit keystore files or passwords.
- Test on multiple Android screen sizes and review permissions.
- Confirm all artwork/audio licences and provide a privacy policy if collecting any data.

## Current prototype scope
The game uses procedurally generated low-poly 3D objects and has no network calls, account system, ads, analytics or data collection. It is an early prototype; successful export and physical-device compatibility must be verified locally.
