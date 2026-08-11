extends CharacterBody3D

@onready var health_component: HealthComponent = $HealthComponent


func _ready() -> void:
	health_component.died.connect(_on_died)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_enemy_damage"):
		take_damage(25.0)
		print("Enemy health: ", health_component.current_health)

func take_damage(amount: float) -> void:
	health_component.take_damage(amount)


func _on_died() -> void:
	queue_free()
