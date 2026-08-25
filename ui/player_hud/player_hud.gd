extends CanvasLayer

@export var player: Node

@onready var health_label: Label = $HealthDisplay/VBoxContainer/HealthLabel
@onready var health_bar: ProgressBar = $HealthDisplay/VBoxContainer/HealthBar


func _ready() -> void:
	if player == null:
		return

	var health_component: HealthComponent = player.get_node("HealthComponent")

	if not health_component.is_node_ready():
		await health_component.ready

	health_component.health_changed.connect(_on_health_changed)

	update_health(
		health_component.current_health,
		health_component.max_health
	)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_build_panel"):
		$BuildPanel.visible = not $BuildPanel.visible


func _on_health_changed(
	current_health: float,
	max_health: float
) -> void:
	update_health(current_health, max_health)


func update_health(
	current_health: float,
	max_health: float
) -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health

	health_label.text = "HP %.0f / %.0f" % [
		current_health,
		max_health
	]
