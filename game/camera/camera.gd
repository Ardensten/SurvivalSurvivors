extends Node3D

@export var target: Node3D

@export_group("Camera Position")
@export var camera_offset: Vector3 = Vector3(12.0, 16.0, 12.0)
@export var look_at_offset: Vector3 = Vector3(0.0, 1.0, 0.0)

@export_group("Following")
@export_range(0.0, 30.0, 0.5)
var follow_speed: float = 10.0

@onready var camera: Camera3D = $Camera3D


func _ready() -> void:
	if target == null:
		push_warning("CameraRig has no target.")
		return

	global_position = target.global_position
	_update_camera_transform()


func _physics_process(delta: float) -> void:
	if target == null:
		return

	var target_position: Vector3 = target.global_position

	global_position = global_position.lerp(
		target_position,
		1.0 - exp(-follow_speed * delta)
	)


func _update_camera_transform() -> void:
	camera.position = camera_offset
	camera.look_at(
		global_position + look_at_offset,
		Vector3.UP
	)
