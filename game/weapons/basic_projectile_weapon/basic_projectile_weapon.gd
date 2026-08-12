extends Node3D
class_name BasicProjectileWeapon

@export var damage: float = 25.0
@export var attacks_per_second: float = 1.0
@export var range: float = 8.0
@export var projectile_scene: PackedScene

var current_target: Node3D
var attack_cooldown_remaining: float = 0.0


func _process(delta: float) -> void:
	attack_cooldown_remaining = max(
		attack_cooldown_remaining - delta,
		0.0
	)

	update_target()

	if has_valid_target() and attack_cooldown_remaining <= 0.0:
		fire_at(current_target)


func update_target() -> void:
	if is_target_valid(current_target):
		return

	current_target = null
	current_target = find_nearest_target()


func find_nearest_target() -> Node3D:
	var enemies := get_tree().get_nodes_in_group("enemy")

	var nearest_enemy: Node3D = null
	var nearest_distance := INF

	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue

		if not enemy is Node3D:
			continue

		if enemy.is_queued_for_deletion():
			continue

		var distance := global_position.distance_to(enemy.global_position)

		if distance > range:
			continue

		if distance < nearest_distance:
			nearest_distance = distance
			nearest_enemy = enemy

	return nearest_enemy


func is_target_valid(target) -> bool:
	if not is_instance_valid(target):
		return false

	if not target is Node3D:
		return false

	if target.is_queued_for_deletion():
		return false

	var distance := global_position.distance_to(target.global_position)

	return distance <= range


func has_valid_target() -> bool:
	return is_target_valid(current_target)


func fire_at(target: Node3D) -> void:
	if projectile_scene == null:
		push_warning("BasicProjectileWeapon has no projectile scene assigned.")
		return

	if not is_instance_valid(target):
		return

	var projectile := projectile_scene.instantiate() as BasicProjectile

	if projectile == null:
		push_error("Projectile scene is not a BasicProjectile.")
		return

	var direction := target.global_position - global_position
	direction.y = 0.0

	projectile.setup(direction, damage)

	get_tree().current_scene.add_child(projectile)
	projectile.global_position = global_position

	attack_cooldown_remaining = get_attack_cooldown()


func get_attack_cooldown() -> float:
	if attacks_per_second <= 0.0:
		return INF

	return 1.0 / attacks_per_second
