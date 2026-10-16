# Controls and gameplay

## Desktop development controls

- **W / Up Arrow:** accelerate forward
- **S / Down Arrow:** reverse
- **A / Left Arrow:** steer left
- **D / Right Arrow:** steer right
- **Esc:** pause or resume

## Android touch controls

Use the on-screen **TURN**, **GO**, and **REVERSE** buttons. Hold a movement button while steering. Use **PAUSE / RESUME** to pause the timer and movement. Use **RESTART MISSION** after a mission ends.

## Objective

Reach the five marked villagers in the flooded village before the three-minute timer expires. Each rescue adds 100 points. This is a fictional game prototype, not an emergency-response simulator.

## Test checklist

- [ ] Touch buttons are visible and tappable on the target phone.
- [ ] HUD remains readable on the phone's landscape aspect ratio.
- [ ] Boat steering, forward and reverse movement work.
- [ ] Rescued count and score update once per villager.
- [ ] Pause freezes the timer and boat movement; resume continues.
- [ ] Restart reloads a fresh mission.
- [ ] No parser/runtime errors in Godot Output or Android logs.
- [ ] Frame rate and memory use are acceptable on the target phone.
