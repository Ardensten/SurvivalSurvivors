extends Area3D
class_name BasicProjectile

@export var speed: float = 12.0
@export var lifetime: float = 3.0

var direction: Vector3 = Vector3.ZERO
var damage: float = 0.0
var lifetime_remaining: float


func _ready() -> void:
	lifetime_remaining = lifetime
	body_entered.connect(_on_body_entered)


func setup(
	start_direction: Vector3,
	projectile_damage: float
) -> void:
	direction = start_direction.normalized()
	damage = projectile_damage


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

	lifetime_remaining -= delta

	if lifetime_remaining <= 0.0:
		queue_free()


func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
