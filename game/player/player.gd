extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var health_component: HealthComponent = $HealthComponent


func _process(_delta: float) -> void:
	# This is only for debugging and is to be removed later.
	if Input.is_action_just_pressed("debug_damage"):
		health_component.take_damage(25.0)

func _ready() -> void:
	health_component.died.connect(_on_died)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func take_damage(amount: float) -> void:
	health_component.take_damage(amount)


func _on_died() -> void:
	SceneManager.restart_scene()
