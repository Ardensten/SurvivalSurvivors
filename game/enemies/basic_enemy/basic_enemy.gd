extends CharacterBody3D

const SPEED := 3.5
const CONTACT_DAMAGE := 10.0
const DAMAGE_COOLDOWN := 1.0

@onready var health_component: HealthComponent = $HealthComponent
@onready var model: Node3D = $Demon
@onready var mesh: MeshInstance3D = $Demon/MonsterArmature/Skeleton3D/Demon_001
@onready var health_label: Label3D = $HealthLabel

var player: Node3D
var damage_cooldown := 0.0

var hit_flash_material: StandardMaterial3D


func _ready() -> void:
	health_component.died.connect(_on_died)
	health_component.health_changed.connect(_on_health_changed)

	player = get_tree().get_first_node_in_group("player")

	update_health_label()
	setup_hit_flash()


func update_health_label() -> void:
	health_label.text = "%.0f / %.0f" % [
		health_component.current_health,
		health_component.max_health
	]


func setup_hit_flash() -> void:
	hit_flash_material = StandardMaterial3D.new()

	hit_flash_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	hit_flash_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	hit_flash_material.albedo_color = Color(1.0, 1.0, 1.0, 0.0)

	mesh.material_overlay = hit_flash_material


func _physics_process(delta: float) -> void:
	if damage_cooldown > 0.0:
		damage_cooldown -= delta

	if not is_on_floor():
		velocity += get_gravity() * delta

	if player == null:
		velocity.x = 0.0
		velocity.z = 0.0
		move_and_slide()
		return

	var direction := player.global_position - global_position
	direction.y = 0.0
	direction = direction.normalized()

	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		rotation.y = atan2(direction.x, direction.z)
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	move_and_slide()

	_check_contact_damage()


func _check_contact_damage() -> void:
	if damage_cooldown > 0.0:
		return

	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()

		if collider != null and collider.is_in_group("player"):
			if collider.has_method("take_damage"):
				collider.take_damage(CONTACT_DAMAGE)
				damage_cooldown = DAMAGE_COOLDOWN
				return


func take_damage(amount: float) -> void:
	health_component.take_damage(amount)


func _on_health_changed(
	_current_health: float,
	_max_health: float
) -> void:
	update_health_label()
	hit_flash()


func hit_flash() -> void:
	if hit_flash_material == null:
		return

	hit_flash_material.albedo_color.a = 1.0

	await get_tree().create_timer(0.08).timeout

	if not is_instance_valid(self):
		return

	hit_flash_material.albedo_color.a = 0.0


func _on_died() -> void:
	set_physics_process(false)
	$CollisionShape3D.set_deferred("disabled", true)

	var tween := create_tween()
	tween.tween_property(
		model,
		"scale",
		Vector3.ZERO,
		0.12
	)
	tween.tween_callback(queue_free)
