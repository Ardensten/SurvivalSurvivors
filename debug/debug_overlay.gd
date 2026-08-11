extends CanvasLayer

@export var player: Node3D

@onready var fps_label: Label = $PanelContainer/MarginContainer/VBoxContainer/FPSLabel
@onready var frame_time_label: Label = $PanelContainer/MarginContainer/VBoxContainer/FrameTimeLabel
@onready var position_label: Label = $PanelContainer/MarginContainer/VBoxContainer/PositionLabel
@onready var version_label: Label = $PanelContainer/MarginContainer/VBoxContainer/VersionLabel


func _ready() -> void:
	visible = false

	var version = ProjectSettings.get_setting(
		"application/config/version",
		"dev"
	)

	version_label.text = "Build: %s" % version


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_debug"):
		visible = not visible

	if not visible:
		return

	fps_label.text = "FPS: %d" % Engine.get_frames_per_second()
	frame_time_label.text = "Frame: %.2f ms" % (delta * 1000.0)

	if player:
		var pos := player.global_position

		position_label.text = "Position: %.1f, %.1f, %.1f" % [
			pos.x,
			pos.y,
			pos.z
		]
	else:
		position_label.text = "Position: N/A"
