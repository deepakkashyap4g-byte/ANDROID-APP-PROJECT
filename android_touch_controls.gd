extends Control

## Touch controls for Indian Monsoon Rescue. Connect these signals to the player/game manager.
signal move_input(direction: Vector2)
signal rescue_pressed
signal pause_pressed

var _stick_center := Vector2.ZERO
var _stick_touch_id := -1
var _stick_radius := 72.0
var _stick_vector := Vector2.ZERO
var _rescue_button: Button
var _pause_button: Button
var _stick_area := Rect2()

func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  mouse_filter = Control.MOUSE_FILTER_IGNORE
  _rescue_button = Button.new()
  _rescue_button.text = "RESCUE"
  _rescue_button.custom_minimum_size = Vector2(112, 64)
  _rescue_button.anchor_left = 1.0
  _rescue_button.anchor_top = 1.0
  _rescue_button.anchor_right = 1.0
  _rescue_button.anchor_bottom = 1.0
  _rescue_button.offset_left = -140
  _rescue_button.offset_top = -100
  _rescue_button.offset_right = -20
  _rescue_button.offset_bottom = -24
  _rescue_button.pressed.connect(func(): rescue_pressed.emit())
  add_child(_rescue_button)
  _pause_button = Button.new()
  _pause_button.text = ""
  _pause_button.custom_minimum_size = Vector2(56, 56)
  _pause_button.anchor_left = 1.0
  _pause_button.anchor_right = 1.0
  _pause_button.offset_left = -76
  _pause_button.offset_top = 20
  _pause_button.offset_right = -20
  _pause_button.offset_bottom = 76
  _pause_button.pressed.connect(func(): pause_pressed.emit())
  add_child(_pause_button)
  _stick_area = Rect2(20, size.y - 190, 190, 170)
  resized.connect(_update_stick_area)

func _update_stick_area() -> void:
  _stick_area = Rect2(20, size.y - 190, 190, 170)
  queue_redraw()

func _input(event: InputEvent) -> void:
  if event is InputEventScreenTouch:
    if event.pressed and _stick_touch_id == -1 and _stick_area.has_point(event.position):
      _stick_touch_id = event.index
      _stick_center = event.position
      _update_stick(event.position)
    elif not event.pressed and event.index == _stick_touch_id:
      _stick_touch_id = -1
      _stick_vector = Vector2.ZERO
      move_input.emit(_stick_vector)
      queue_redraw()
  elif event is InputEventScreenDrag and event.index == _stick_touch_id:
    _update_stick(event.position)

func _update_stick(position: Vector2) -> void:
  _stick_vector = ((position - _stick_center) / _stick_radius).limit_length(1.0)
  move_input.emit(_stick_vector)
  queue_redraw()

func _draw() -> void:
  var base := Vector2(105, size.y - 105)
  draw_circle(base, _stick_radius, Color(0.1, 0.15, 0.2, 0.35))
  draw_circle(base + _stick_vector * 42.0, 30.0, Color(0.85, 0.9, 1.0, 0.65))
