extends CharacterBody3D

const SPEED := 5.0
const CONTACT_DAMAGE := 10.0
const DAMAGE_COOLDOWN := 1.0

@onready var health_component: HealthComponent = $HealthComponent

var player: Node3D
var damage_cooldown := 0.0


func _ready() -> void:
	health_component.died.connect(_on_died)

	player = get_tree().get_first_node_in_group("player")


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


func _on_died() -> void:
	queue_free()
