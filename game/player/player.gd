extends CharacterBody3D

const SPEED := 5.0
const ACCELERATION := 25.0
const DECELERATION := 30.0
const ROTATION_SPEED := 12.0
const JUMP_VELOCITY := 4.5

@onready var health_component: HealthComponent = $HealthComponent
@onready var animation_player: AnimationPlayer = $UAL1_Standard_RM/AnimationPlayer


func _ready() -> void:
	health_component.died.connect(_on_died)


func _process(_delta: float) -> void:
	# This is only for debugging and is to be removed later.
	if Input.is_action_just_pressed("debug_damage"):
		health_component.take_damage(25.0)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	)

	var direction := Vector3(
		input_dir.x,
		0.0,
		input_dir.y
	).normalized()

	if direction != Vector3.ZERO:
		velocity.x = move_toward(
			velocity.x,
			direction.x * SPEED,
			ACCELERATION * delta
		)

		velocity.z = move_toward(
			velocity.z,
			direction.z * SPEED,
			ACCELERATION * delta
		)

		var target_rotation := atan2(direction.x, direction.z)

		rotation.y = lerp_angle(
			rotation.y,
			target_rotation,
			ROTATION_SPEED * delta
		)

		if animation_player.current_animation != "Walk":
			animation_player.play("Walk")
	else:
		velocity.x = move_toward(
			velocity.x,
			0.0,
			DECELERATION * delta
		)

		velocity.z = move_toward(
			velocity.z,
			0.0,
			DECELERATION * delta
		)

		if animation_player.current_animation == "Walk":
			animation_player.play("Idle")

	move_and_slide()


func take_damage(amount: float) -> void:
	health_component.take_damage(amount)


func _on_died() -> void:
	SceneManager.restart_scene()
