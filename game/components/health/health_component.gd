extends Node
class_name HealthComponent

signal died
signal health_changed(current_health: float, max_health: float)

@export var max_health: float = 100.0

@onready var current_health: float = max_health
var is_dead: bool = false


func take_damage(amount: float) -> void:
	if is_dead:
		return

	if amount <= 0.0:
		return

	current_health = max(current_health - amount, 0.0)
	health_changed.emit(current_health, max_health)

	if current_health <= 0.0:
		die()


func heal(amount: float) -> void:
	if is_dead:
		return

	if amount <= 0.0:
		return

	current_health = min(current_health + amount, max_health)
	health_changed.emit(current_health, max_health)


func die() -> void:
	if is_dead:
		return

	is_dead = true
	died.emit()
