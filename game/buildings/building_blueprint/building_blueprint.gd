class_name BuildingBlueprint
extends Node3D

var definition: BuildingDefinition
var construction_progress: float = 0.0
var player_in_range: bool = false

@onready var progress_label: Label3D = $ProgressLabel

func _process(delta: float) -> void:
	if definition == null:
		return

	if player_in_range:
		construction_progress += delta
		construction_progress = min(
			construction_progress,
			definition.construction_time
		)
	
	if construction_progress >= definition.construction_time:
		complete_construction()
		return
	
	var progress_ratio := construction_progress / definition.construction_time
	var progress_percent := int(progress_ratio * 100.0)
	
	progress_label.text = "%d%%" % progress_percent

func setup(building_definition: BuildingDefinition) -> void:
	definition = building_definition

	if definition.scene == null:
		return

	var visual := definition.scene.instantiate() as Node3D
	$VisualRoot.add_child(visual)
	
	_disable_collision_recursive(visual)
	_apply_blueprint_visual(visual)


func _disable_collision_recursive(node: Node) -> void:
	if node is CollisionObject3D:
		node.collision_layer = 0
		node.collision_mask = 0

	for child in node.get_children():
		_disable_collision_recursive(child)


func _apply_blueprint_visual(node: Node) -> void:
	if node is MeshInstance3D:
		var material := StandardMaterial3D.new()
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		material.albedo_color = Color(0.3, 0.6, 1.0, 0.45)

		node.material_override = material

	for child in node.get_children():
		_apply_blueprint_visual(child)


func complete_construction() -> void:
	if definition == null or definition.scene == null:
		return

	var building := definition.scene.instantiate() as Node3D

	get_tree().current_scene.add_child(building)
	building.global_transform = global_transform

	queue_free()


func _on_construction_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = true


func _on_construction_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
