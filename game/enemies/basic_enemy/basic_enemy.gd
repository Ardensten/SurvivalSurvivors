extends CharacterBody3D

@export var move_speed: float = 3.0
@export var stop_distance: float = 1.5

@export var attack_range: float = 1.75
@export var attack_damage: float = 10.0
@export var attack_cooldown: float = 1.0

@onready var health_component: HealthComponent = $HealthComponent

var player: Node3D
var attack_cooldown_remaining: float = 0.0


func _ready() -> void:
	health_component.died.connect(_on_died)

	player = get_tree().get_first_node_in_group("player")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_enemy_damage"):
		take_damage(25.0)
		print("Enemy health: ", health_component.current_health)


func _physics_process(delta: float) -> void:
	if not is_instance_valid(player):
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	attack_cooldown_remaining = max(
		attack_cooldown_remaining - delta,
		0.0
	)

	var offset := player.global_position - global_position
	var horizontal_offset := Vector3(offset.x, 0.0, offset.z)
	var distance := horizontal_offset.length()

	if distance > stop_distance:
		var direction := horizontal_offset.normalized()

		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	move_and_slide()

	if distance <= attack_range:
		try_attack()


func try_attack() -> void:
	if attack_cooldown_remaining > 0.0:
		return

	if not is_instance_valid(player):
		return

	player.take_damage(attack_damage)
	attack_cooldown_remaining = attack_cooldown

	print("Enemy attacked player for ", attack_damage)


func take_damage(amount: float) -> void:
	health_component.take_damage(amount)


func _on_died() -> void:
	queue_free()
