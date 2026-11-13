extends Control
## Analog virtual stick used by the mobile action prototype.

signal vector_changed(value: Vector2)

const DEADZONE := 0.12

var vector := Vector2.ZERO
var _touch_index := -1
var _mouse_active := false

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	queue_redraw()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and _touch_index == -1:
			_touch_index = event.index
			_update_vector(event.position)
			accept_event()
		elif not event.pressed and event.index == _touch_index:
			_touch_index = -1
			_set_vector(Vector2.ZERO)
			accept_event()
	elif event is InputEventScreenDrag and event.index == _touch_index:
		_update_vector(event.position)
		accept_event()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_mouse_active = event.pressed
		if _mouse_active:
			_update_vector(event.position)
		else:
			_set_vector(Vector2.ZERO)
		accept_event()
	elif event is InputEventMouseMotion and _mouse_active:
		_update_vector(event.position)
		accept_event()

func _update_vector(local_position: Vector2) -> void:
	var radius := minf(size.x, size.y) * 0.5
	if radius <= 0.0:
		_set_vector(Vector2.ZERO)
		return
	var offset := local_position - size * 0.5
	var raw := offset / radius
	var strength := minf(raw.length(), 1.0)
	if strength <= DEADZONE:
		_set_vector(Vector2.ZERO)
		return
	var adjusted_strength := (strength - DEADZONE) / (1.0 - DEADZONE)
	_set_vector(raw.normalized() * adjusted_strength)

func _set_vector(value: Vector2) -> void:
	if vector.is_equal_approx(value):
		return
	vector = value
	vector_changed.emit(vector)
	queue_redraw()

func _draw() -> void:
	var center := size * 0.5
	var radius := minf(size.x, size.y) * 0.5 - 3.0
	draw_circle(center, radius, Color(0.05, 0.09, 0.15, 0.36))
	draw_arc(center, radius, 0.0, TAU, 48, Color(0.50, 0.82, 0.98, 0.72), 3.0, true)
	draw_circle(center + vector * maxf(0.0, radius - 27.0), 25.0, Color(0.72, 0.91, 1.0, 0.84))
