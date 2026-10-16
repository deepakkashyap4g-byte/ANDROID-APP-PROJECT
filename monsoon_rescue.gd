# Indian Monsoon Rescue - Godot 4 single-file prototype
# Attach this script to a Node3D root in a new Godot 4 project.
# It procedurally creates a simple flood village, boat, survivors, HUD and controls.
extends Node3D

const WATER_COLOR := Color(0.08, 0.34, 0.55)
const LAND_COLOR := Color(0.22, 0.42, 0.20)
const BOAT_COLOR := Color(0.45, 0.20, 0.08)
const RESCUE_TOTAL := 5

var boat: Node3D
var camera: Camera3D
var hud: Label
var status_label: Label
var score := 0
var rescued := 0
var elapsed := 0.0
var time_limit := 180.0
var speed := 0.0
var steering := 0.0
var paused := false
var ended := false
var survivors: Array[Node3D] = []
var forward_touch := false
var back_touch := false
var left_touch := false
var right_touch := false

func _ready() -> void:
  _build_world()
  _build_boat()
  _build_survivors()
  _build_camera()
  _build_ui()
  _update_hud()

func _process(delta: float) -> void:
  if ended or paused:
    return
  elapsed += delta
  if elapsed >= time_limit:
    _end_game(false)
    return
  var forward_input := Input.get_action_strength("move_forward") - Input.get_action_strength("move_back")
  var steer_input := Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left")
  if forward_touch: forward_input = maxf(forward_input, 1.0)
  if back_touch: forward_input = minf(forward_input, -1.0)
  if right_touch: steer_input = maxf(steer_input, 1.0)
  if left_touch: steer_input = minf(steer_input, -1.0)
  if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP): forward_input = 1.0
  if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN): forward_input = -1.0
  if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT): steer_input = -1.0
  if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT): steer_input = 1.0
  speed = move_toward(speed, forward_input * 8.0, delta * 3.5)
  steering = move_toward(steering, steer_input, delta * 4.0)
  boat.rotate_y(-steering * delta * (0.6 + absf(speed) * 0.08))
  boat.global_position += -boat.global_basis.z * speed * delta
  boat.global_position.x = clampf(boat.global_position.x, -22.0, 22.0)
  boat.global_position.z = clampf(boat.global_position.z, -25.0, 25.0)
  camera.global_position = camera.global_position.lerp(boat.global_position + Vector3(0, 8, 11), delta * 3.0)
  camera.look_at(boat.global_position + Vector3(0, 0.5, 0), Vector3.UP)
  _check_rescues()
  _update_hud()

func _unhandled_input(event: InputEvent) -> void:
  if event.is_action_pressed("ui_cancel"):
    paused = not paused
    if status_label: status_label.text = "PAUSED  press Esc / Pause to continue" if paused else "Rescue the villagers!"

func _mat(color: Color) -> StandardMaterial3D:
  var m := StandardMaterial3D.new()
  m.albedo_color = color
  m.roughness = 0.9
  return m

func _box(parent: Node3D, label: String, pos: Vector3, size: Vector3, color: Color) -> MeshInstance3D:
  var mesh := BoxMesh.new()
  mesh.size = size
  var item := MeshInstance3D.new()
  item.name = label
  item.mesh = mesh
  item.position = pos
  item.material_override = _mat(color)
  parent.add_child(item)
  return item

func _build_world() -> void:
  var ground := _box(self, "FloodedVillageLand", Vector3(0, -0.8, 0), Vector3(52, 1, 58), LAND_COLOR)
  var water := _box(self, "FloodWater", Vector3(0, -0.12, 0), Vector3(48, 0.18, 54), WATER_COLOR)
  # Raised banks and a few low-poly houses around the flood channel.
  _box(self, "WestBank", Vector3(-24.5, 0.15, 0), Vector3(3, 1.2, 58), Color(0.30, 0.32, 0.16))
  _box(self, "EastBank", Vector3(24.5, 0.15, 0), Vector3(3, 1.2, 58), Color(0.30, 0.32, 0.16))
  for i in range(6):
    var z := -22.0 + float(i) * 8.5
    _make_house(Vector3(-19.0, 0.8, z), i)
    _make_house(Vector3(19.0, 0.8, z + 3.0), i + 6)
  # Simple floating logs and debris make the flood area readable.
  for i in range(12):
    var log := _box(self, "FloatingDebris", Vector3(randf_range(-14, 14), 0.02, randf_range(-24, 24)), Vector3(randf_range(0.7, 1.8), 0.12, 0.3), Color(0.28, 0.17, 0.08))
    log.rotation.y = randf_range(0.0, TAU)
  var sun := DirectionalLight3D.new()
  sun.rotation_degrees = Vector3(-55, -25, 0)
  sun.light_energy = 1.1
  add_child(sun)
  var env := WorldEnvironment.new()
  var environment := Environment.new()
  environment.background_mode = Environment.BG_SKY
  environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
  environment.ambient_light_color = Color(0.58, 0.68, 0.72)
  environment.ambient_light_energy = 0.7
  env.environment = environment
  add_child(env)

func _make_house(pos: Vector3, seed_id: int) -> void:
  var house := Node3D.new()
  house.name = "VillageHouse_%02d" % seed_id
  house.position = pos
  add_child(house)
  var wall_color := [Color(0.72, 0.55, 0.32), Color(0.78, 0.68, 0.47), Color(0.56, 0.40, 0.28)][seed_id % 3]
  _box(house, "Walls", Vector3.ZERO, Vector3(4.2, 2.5, 3.5), wall_color)
  _box(house, "Roof", Vector3(0, 1.55, 0), Vector3(4.8, 0.45, 4.1), Color(0.34, 0.18, 0.12))
  _box(house, "Door", Vector3(0, -0.35, -1.78), Vector3(0.8, 1.4, 0.08), Color(0.20, 0.10, 0.05))

func _build_boat() -> void:
  boat = Node3D.new()
  boat.name = "RescueBoat"
  boat.position = Vector3(0, 0.28, 20)
  add_child(boat)
  _box(boat, "Hull", Vector3(0, 0, 0), Vector3(2.1, 0.42, 4.0), BOAT_COLOR)
  _box(boat, "Bow", Vector3(0, 0.04, -2.05), Vector3(1.4, 0.32, 0.45), Color(0.58, 0.30, 0.10))
  _box(boat, "Seat", Vector3(0, 0.28, 0.35), Vector3(1.25, 0.16, 0.45), Color(0.15, 0.13, 0.10))
  _box(boat, "RescueKit", Vector3(0.55, 0.34, 0.85), Vector3(0.35, 0.35, 0.35), Color(0.95, 0.65, 0.08))

func _build_survivors() -> void:
  var places := [Vector3(-10, 0.2, 13), Vector3(11, 0.2, 7), Vector3(-8, 0.2, -2), Vector3(9, 0.2, -12), Vector3(0, 0.2, -21)]
  for i in range(RESCUE_TOTAL):
    var person := Node3D.new()
    person.name = "Villager_%02d" % (i + 1)
    person.position = places[i]
    add_child(person)
    _box(person, "Body", Vector3(0, 0.55, 0), Vector3(0.55, 0.8, 0.35), [Color(0.9, 0.3, 0.16), Color(0.95, 0.75, 0.18), Color(0.2, 0.65, 0.45)][i % 3])
    var head := MeshInstance3D.new()
    var sphere := SphereMesh.new()
    sphere.radius = 0.23
    sphere.height = 0.46
    head.mesh = sphere
    head.position = Vector3(0, 1.12, 0)
    head.material_override = _mat(Color(0.68, 0.43, 0.28))
    person.add_child(head)
    _box(person, "FloatRing", Vector3(0, 0.18, 0), Vector3(0.9, 0.12, 0.7), Color(1.0, 0.55, 0.05))
    survivors.append(person)

func _build_camera() -> void:
  camera = Camera3D.new()
  camera.name = "FollowCamera"
  camera.position = Vector3(0, 9, 31)
  camera.fov = 68
  add_child(camera)
  camera.current = true
  camera.look_at(Vector3(0, 0, 15), Vector3.UP)

func _build_ui() -> void:
  var layer := CanvasLayer.new()
  add_child(layer)
  var panel := PanelContainer.new()
  panel.position = Vector2(12, 12)
  panel.custom_minimum_size = Vector2(330, 88)
  layer.add_child(panel)
  var stack := VBoxContainer.new()
  panel.add_child(stack)
  hud = Label.new()
  hud.text = "INDIAN MONSOON RESCUE"
  hud.add_theme_font_size_override("font_size", 18)
  stack.add_child(hud)
  status_label = Label.new()
  status_label.text = "Rescue the villagers!"
  stack.add_child(status_label)
  var help := Label.new()
  help.text = "WASD / arrows: drive  |  Esc: pause  |  Reach survivors"
  stack.add_child(help)
  var controls := HBoxContainer.new()
  controls.anchor_left = 0.0
  controls.anchor_top = 1.0
  controls.anchor_right = 1.0
  controls.anchor_bottom = 1.0
  controls.offset_left = 12
  controls.offset_top = -78
  controls.offset_right = -12
  controls.offset_bottom = -12
  layer.add_child(controls)
  _add_hold_button(controls, " TURN", "left")
  _add_hold_button(controls, " GO", "forward")
  _add_hold_button(controls, " REVERSE", "back")
  _add_hold_button(controls, "TURN ", "right")
  var pause_button := Button.new()
  pause_button.text = "PAUSE / RESUME"
  pause_button.custom_minimum_size = Vector2(140, 54)
  pause_button.pressed.connect(func():
    paused = not paused
    status_label.text = "PAUSED" if paused else "Rescue the villagers!"
  )
  controls.add_child(pause_button)

func _add_hold_button(parent: HBoxContainer, caption: String, action: String) -> void:
  var b := Button.new()
  b.text = caption
  b.custom_minimum_size = Vector2(100, 54)
  b.button_down.connect(func(): _set_touch(action, true))
  b.button_up.connect(func(): _set_touch(action, false))
  parent.add_child(b)

func _set_touch(action: String, pressed: bool) -> void:
  match action:
    "forward": forward_touch = pressed
    "back": back_touch = pressed
    "left": left_touch = pressed
    "right": right_touch = pressed

func _check_rescues() -> void:
  for person in survivors:
    if is_instance_valid(person) and boat.global_position.distance_to(person.global_position) < 2.8:
      person.queue_free()
      score += 100
      rescued += 1
      status_label.text = "Villager rescued! +100 points"
      if rescued >= RESCUE_TOTAL:
        _end_game(true)
      return

func _update_hud() -> void:
  if hud:
    var remaining := maxi(0, int(time_limit - elapsed))
    hud.text = "INDIAN MONSOON RESCUE  |  Rescued %d/%d  |  Score %d  |  Time %02d:%02d" % [rescued, RESCUE_TOTAL, score, remaining / 60, remaining % 60]

func _end_game(won: bool) -> void:
  ended = true
  speed = 0.0
  if status_label:
    status_label.text = "MISSION COMPLETE! All villagers saved  Score %d" % score if won else "TIME UP! Rescued %d/%d  restart to try again" % [rescued, RESCUE_TOTAL]
  var layer := get_node_or_null("EndScreen")
  if layer == null:
    layer = CanvasLayer.new()
    layer.name = "EndScreen"
    add_child(layer)
    var center := CenterContainer.new()
    center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    layer.add_child(center)
    var panel := PanelContainer.new()
    panel.custom_minimum_size = Vector2(360, 140)
    center.add_child(panel)
    var col := VBoxContainer.new()
    panel.add_child(col)
    var message := Label.new()
    message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    message.text = "MISSION COMPLETE!" if won else "TIME UP  TRY AGAIN"
    col.add_child(message)
    var restart := Button.new()
    restart.text = "RESTART MISSION"
    restart.pressed.connect(func(): get_tree().reload_current_scene())
    col.add_child(restart)
