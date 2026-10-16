# Android build and verification checklist

This file documents the repeatable path to a phone-installable build. It does not claim that an APK has already been generated.

## Requirements

- Godot 4.x editor and export templates matching the exact editor version.
- Android SDK command-line tools, Android platform tools, and the Android build tools required by that Godot version.
- A supported Java Development Kit (JDK).
- USB debugging enabled on a test phone, or another trusted way to transfer the APK.

## Export steps

1. Open `project.godot` in Godot.
2. Install the matching export templates through **Editor > Manage Export Templates**.
3. Set the Android SDK and Java SDK paths in **Editor > Editor Settings > Export > Android**.
4. Open **Project > Export** and select the Android preset.
5. Check `com.example.indianmonsoonrescue` and change it to a package ID you own before release.
6. Export a debug APK first. Resolve every export error before attempting a release build.
7. Install the APK on a real Android phone and test the full mission.

## Device acceptance

- Launches without a crash.
- Displays in landscape with controls inside the safe visible area.
- Boat movement responds to touch input.
- HUD, timer, rescue counter, pause and restart all work.
- Performance remains acceptable on the intended low-end device.

## Release safety

Keep keystores, signing passwords, local SDK paths, generated `.apk`/`.aab` files, and build caches out of Git. Do not publish until the app has been tested on real devices and the package ID, version, permissions and store policy requirements have been reviewed.
