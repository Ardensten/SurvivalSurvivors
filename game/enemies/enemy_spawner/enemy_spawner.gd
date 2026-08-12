extends Node3D

@export var enabled: bool = true
@export var enemy_scene: PackedScene

@export var spawn_interval: float = 2.0
@export var max_active_enemies: int = 10

@export var min_spawn_distance: float = 8.0
@export var max_spawn_distance: float = 15.0

var player: Node3D

@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()


func _on_spawn_timer_timeout() -> void:
	if not enabled:
		return

	if enemy_scene == null:
		return

	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player")

	if not is_instance_valid(player):
		return

	if get_active_enemy_count() >= max_active_enemies:
		return

	spawn_enemy()


func spawn_enemy() -> void:
	var enemy := enemy_scene.instantiate() as Node3D

	if enemy == null:
		push_error("EnemySpawner: enemy_scene root must inherit Node3D.")
		return

	var spawn_position := get_spawn_position()

	get_tree().current_scene.add_child(enemy)
	enemy.global_position = spawn_position


func get_spawn_position() -> Vector3:
	var minimum_distance = max(min_spawn_distance, 0.0)
	var maximum_distance = max(max_spawn_distance, minimum_distance)

	var angle := randf_range(0.0, TAU)
	var distance := randf_range(
		minimum_distance,
		maximum_distance
	)

	var offset := Vector3(
		cos(angle) * distance,
		0.0,
		sin(angle) * distance
	)

	return player.global_position + offset


func get_active_enemy_count() -> int:
	return get_tree().get_nodes_in_group("enemy").size()
